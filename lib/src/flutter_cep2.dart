import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'cep.dart';
import 'cep_exception.dart';
import 'cep_utils.dart';

/// A Brazilian ZIP code (CEP) lookup service backed by ViaCEP, with optional
/// fallback to other providers and an optional in-memory cache.
///
/// Example usage:
/// ```dart
/// final cepService = FlutterCep2();
/// try {
///   final result = await cepService.search('01310-100');
///   print('Address: ${result.logradouro}');
/// } on CepException catch (e) {
///   print('Error: ${e.message}');
/// }
/// ```
class FlutterCep2 {
  static final _uf = RegExp(r'^[A-Za-z]{2}$');

  /// HTTP client used for making requests.
  final http.Client _client;

  /// Whether [_client] was created here, and so is closed by [dispose].
  final bool _ownsClient;

  /// How long a request may take before it fails with [CepException].
  final Duration timeout;

  /// Providers [search] asks, in order, until one finds the CEP.
  final List<CepProvider> providers;

  /// Successful answers kept in memory; null when caching is off.
  final _Cache? _cache;

  /// Creates a new instance of [FlutterCep2].
  ///
  /// Optionally accepts a custom HTTP [client]; a client passed in is left
  /// open by [dispose]. Requests fail after [timeout] (10 seconds by default).
  ///
  /// [providers] lists who [search] asks, in order (ViaCEP only by default).
  /// When one fails or does not know the CEP, the next one is tried.
  ///
  /// With [cacheDuration], successful answers of [search] and [searchAddress]
  /// are kept in memory for that long, so repeated lookups skip the network.
  /// The cache holds at most [cacheMaxEntries] answers (1000 by default),
  /// dropping the oldest.
  FlutterCep2({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
    List<CepProvider> providers = const [CepProvider.viaCep],
    Duration? cacheDuration,
    int cacheMaxEntries = 1000,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null,
        providers = providers.isEmpty
            ? throw ArgumentError.value(providers, 'providers', 'is empty')
            : List.unmodifiable(providers),
        _cache = cacheMaxEntries < 1
            ? throw ArgumentError.value(
                cacheMaxEntries, 'cacheMaxEntries', 'must be at least 1')
            : cacheDuration == null
                ? null
                : _Cache(cacheDuration, cacheMaxEntries);

  /// Searches for ZIP code information.
  ///
  /// [cep] is the Brazilian ZIP code, with or without formatting. [output]
  /// picks the format ViaCEP answers in; the result is the same [Cep]. Other
  /// providers always answer in JSON.
  ///
  /// [providers] are tried in order. When all of them fail, the error is
  /// [CepErrorType.notFound] if any provider said the CEP does not exist, and
  /// otherwise the last provider's error. With more than one provider, its
  /// [CepException.providerErrors] holds what each of them said.
  ///
  /// Throws [CepException]; its [CepException.type] says why.
  Future<Cep> search(
    String cep, {
    CepOutputFormat output = CepOutputFormat.json,
  }) async {
    final digits = cepDigits(cep);
    if (digits == null) {
      throw const CepException(
        'Invalid ZIP code format',
        type: CepErrorType.invalidFormat,
      );
    }

    final key = 'cep:$digits';
    if (_cache?.get(key) case final Cep hit) return hit;

    final errors = <CepProvider, CepException>{};
    for (final provider in providers) {
      try {
        final result = await _lookup(provider, digits, output);
        _cache?.put(key, result);
        return result;
      } on CepException catch (e) {
        errors[provider] = e;
      }
    }
    final chosen = errors.values.firstWhere(
      (e) => e.type == CepErrorType.notFound,
      orElse: () => errors.values.last,
    );
    if (errors.length == 1) throw chosen;
    throw CepException(
      chosen.message,
      type: chosen.type,
      providerErrors: Map.unmodifiable(errors),
    );
  }

  Future<Cep> _lookup(
    CepProvider provider,
    String digits,
    CepOutputFormat output,
  ) async {
    switch (provider) {
      case CepProvider.viaCep:
        final data = await _get(_viaCep([digits], output), output);
        if (data is! Map<String, Object?>) {
          throw _invalidResponse('expected an object, got ${data.runtimeType}');
        }
        // ViaCEP has sent `"erro": true` and, today, `"erro": "true"`.
        final erro = data['erro'];
        if (erro == true || erro == 'true') throw _notFound;
        return _cep(data, provider);

      case CepProvider.brasilApi:
        final data = await _get(
          Uri.https('brasilapi.com.br', '/api/cep/v2/$digits'),
          CepOutputFormat.json,
          notFoundOn404: true,
        );
        try {
          final map = data as Map<String, Object?>;
          final ibge = switch (map['ibge']) {
            null => '',
            {'city': final String city} => city,
            final other => throw FormatException('Unexpected ibge: $other'),
          };
          // A GeoJSON point with the numbers as strings; often missing.
          final (lat, lng) = switch (map['location']) {
            {
              'coordinates': {
                'latitude': final Object lat,
                'longitude': final Object lng,
              }
            } =>
              (double.tryParse('$lat'), double.tryParse('$lng')),
            _ => (null, null),
          };
          return Cep(
            cep: formatCep(digits)!,
            logradouro: map['street'] as String? ?? '',
            bairro: map['neighborhood'] as String? ?? '',
            localidade: map['city'] as String? ?? '',
            uf: map['state'] as String? ?? '',
            ibge: ibge,
            latitude: lng == null ? null : lat,
            longitude: lat == null ? null : lng,
            provider: provider,
          );
        } catch (e) {
          throw _invalidResponse(e);
        }

      case CepProvider.openCep:
        final data = await _get(
          Uri.https('opencep.com', '/v1/$digits'),
          CepOutputFormat.json,
          notFoundOn404: true,
        );
        return _cep(data, provider);
    }
  }

  /// Searches ZIP codes by address.
  ///
  /// [uf] is the two-letter state code; [city] and [street] need at least
  /// three characters each, as ViaCEP requires. ViaCEP matches [street] by
  /// prefix of each word and returns at most 50 results. No match is an
  /// empty list, not an error.
  ///
  /// Throws [CepException]; its [CepException.type] says why.
  Future<List<Cep>> searchAddress(
    String uf,
    String city,
    String street, {
    CepOutputFormat output = CepOutputFormat.json,
  }) async {
    final state = uf.trim();
    final town = city.trim();
    final road = street.trim();
    if (!_uf.hasMatch(state) || town.length < 3 || road.length < 3) {
      throw const CepException(
        'Invalid address: UF needs 2 letters, city and street 3 characters',
        type: CepErrorType.invalidFormat,
      );
    }

    final key = 'address:$state/$town/$road'.toLowerCase();
    // Copies, so a caller sorting its list does not change the cached one.
    if (_cache?.get(key) case final List<Cep> hit) return List.of(hit);

    final data = await _get(_viaCep([state, town, road], output), output);
    if (data is! List) {
      throw _invalidResponse('expected a list, got ${data.runtimeType}');
    }
    final result = [for (final item in data) _cep(item, CepProvider.viaCep)];
    _cache?.put(key, List<Cep>.unmodifiable(result));
    return result;
  }

  /// `/ws/<segments>/<output>` on ViaCEP; pathSegments escapes a `/` typed
  /// inside a city or street.
  static Uri _viaCep(List<String> segments, CepOutputFormat output) => Uri(
        scheme: 'https',
        host: 'viacep.com.br',
        pathSegments: ['ws', ...segments, output.value],
      );

  /// GETs [uri] and decodes the body in [output] format. With [notFoundOn404],
  /// a 404 means the provider does not know the CEP.
  Future<Object?> _get(
    Uri uri,
    CepOutputFormat output, {
    bool notFoundOn404 = false,
  }) async {
    final abort = Completer<void>();
    final http.Response response;
    try {
      // Clients that support it (IOClient, BrowserClient...) drop the
      // connection on abort; the rest just stop being awaited.
      response = await _client
          .send(http.AbortableRequest('GET', uri, abortTrigger: abort.future))
          .then(http.Response.fromStream)
          .timeout(timeout);
    } on TimeoutException {
      abort.complete();
      throw const CepException(
        'Request timed out',
        type: CepErrorType.timeout,
      );
    } catch (e) {
      throw CepException('Network error: $e', type: CepErrorType.network);
    }

    if (notFoundOn404 && response.statusCode == 404) throw _notFound;
    if (response.statusCode != 200) {
      throw CepException(
        'HTTP ${response.statusCode}: Failed to fetch ZIP code data',
        type: CepErrorType.http,
      );
    }

    try {
      // The providers answer in UTF-8, with or without a charset header.
      final body = utf8.decode(response.bodyBytes);
      return switch (output) {
        CepOutputFormat.json => jsonDecode(body),
        CepOutputFormat.xml => _xml(body),
      };
    } catch (e) {
      throw _invalidResponse(e);
    }
  }

  static Cep _cep(Object? data, CepProvider provider) {
    try {
      // The provider is ours to say; a `provider` key in the body is ignored.
      return Cep.fromJson(
          {...data as Map<String, dynamic>, 'provider': provider.name});
    } catch (e) {
      throw _invalidResponse(e);
    }
  }

  /// Reads `<xmlcep>` into a field map, or into a list of them when it wraps
  /// `<enderecos>` (address search).
  static Object _xml(String body) {
    final root = XmlDocument.parse(body).rootElement;
    if (root.name.local != 'xmlcep') {
      throw FormatException('Unexpected root element <${root.name.local}>');
    }
    final list = root.getElement('enderecos');
    if (list != null) {
      return [for (final e in list.childElements) _xmlFields(e)];
    }
    return _xmlFields(root);
  }

  static Map<String, String> _xmlFields(XmlElement element) =>
      {for (final e in element.childElements) e.name.local: e.innerText};

  static const _notFound = CepException(
    'ZIP code not found',
    type: CepErrorType.notFound,
  );

  static CepException _invalidResponse(Object error) => CepException(
        'Invalid response: $error',
        type: CepErrorType.invalidResponse,
      );

  /// Closes the HTTP client.
  ///
  /// A client passed to the constructor is left open for its owner.
  void dispose() {
    if (_ownsClient) _client.close();
  }
}

/// Output format options for ZIP code search.
enum CepOutputFormat {
  /// JSON format response.
  json('json'),

  /// XML format response.
  xml('xml');

  const CepOutputFormat(this.value);

  /// The string value used in API requests.
  final String value;
}

/// A CEP lookup service [FlutterCep2.search] can ask.
enum CepProvider {
  /// [ViaCEP](https://viacep.com.br), the default. The only one with XML
  /// output and address search, and the only one that fills `complemento`,
  /// `ddd`, `gia` and `siaf`.
  viaCep,

  /// [BrasilAPI](https://brasilapi.com.br), which itself queries several CEP
  /// sources. Fills street, neighborhood, city, state, IBGE code and, when it
  /// knows them, the only provider to do so, [Cep.latitude] and
  /// [Cep.longitude].
  brasilApi,

  /// [OpenCEP](https://opencep.com), with the same fields as ViaCEP except
  /// `ddd`, `gia` and `siaf`.
  openCep,
}

/// In-memory store of successful answers that expire after [duration].
class _Cache {
  _Cache(this.duration, this.maxEntries);

  /// How long an answer stays valid.
  final Duration duration;

  // shortcut: drops the oldest entry, not the least recently used; switch to
  // LRU if hit rates on big caches matter.
  /// How many answers are kept at most.
  final int maxEntries;

  // A map literal is a LinkedHashMap: keys keep insertion order.
  final _entries = <String, (Object, DateTime)>{};

  Object? get(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.$2)) {
      _entries.remove(key);
      return null;
    }
    return entry.$1;
  }

  void put(String key, Object value) {
    _entries.remove(key);
    if (_entries.length >= maxEntries) _entries.remove(_entries.keys.first);
    _entries[key] = (value, DateTime.now().add(duration));
  }
}

/// Deprecated alias of [FlutterCep2].
@Deprecated('Use FlutterCep2 instead')
// ignore: camel_case_types
typedef flutter_cep2 = FlutterCep2;

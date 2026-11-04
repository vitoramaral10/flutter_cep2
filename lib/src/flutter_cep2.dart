import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'cep.dart';
import 'cep_exception.dart';

/// A Brazilian ZIP code (CEP) lookup service using the ViaCEP API.
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
  static const _host = 'viacep.com.br';
  static final _nonDigits = RegExp(r'[^0-9]');
  static final _uf = RegExp(r'^[A-Za-z]{2}$');

  /// HTTP client used for making requests.
  final http.Client _client;

  /// Whether [_client] was created here, and so is closed by [dispose].
  final bool _ownsClient;

  /// How long a request may take before it fails with [CepException].
  final Duration timeout;

  /// Creates a new instance of [FlutterCep2].
  ///
  /// Optionally accepts a custom HTTP [client]; a client passed in is left
  /// open by [dispose]. Requests fail after [timeout] (10 seconds by default).
  FlutterCep2({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  /// Searches for ZIP code information.
  ///
  /// [cep] is the Brazilian ZIP code, with or without formatting. [output]
  /// picks the format ViaCEP answers in; the result is the same [Cep].
  ///
  /// Throws [CepException]; its [CepException.type] says why.
  Future<Cep> search(
    String cep, {
    CepOutputFormat output = CepOutputFormat.json,
  }) async {
    final digits = cep.replaceAll(_nonDigits, '');
    if (digits.length != 8) {
      throw const CepException(
        'Invalid ZIP code format',
        type: CepErrorType.invalidFormat,
      );
    }

    final data = await _get([digits], output);
    if (data is! Map<String, Object?>) {
      throw _invalidResponse('expected an object, got ${data.runtimeType}');
    }

    // ViaCEP has sent `"erro": true` and, today, `"erro": "true"`.
    final erro = data['erro'];
    if (erro == true || erro == 'true') {
      throw const CepException(
        'ZIP code not found',
        type: CepErrorType.notFound,
      );
    }

    return _cep(data);
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

    final data = await _get([state, town, road], output);
    if (data is! List) {
      throw _invalidResponse('expected a list, got ${data.runtimeType}');
    }
    return [for (final item in data) _cep(item)];
  }

  /// GETs `/ws/<segments>/<output>` from ViaCEP and decodes the body.
  Future<Object?> _get(List<String> segments, CepOutputFormat output) async {
    final abort = Completer<void>();
    final http.Response response;
    try {
      // Clients that support it (IOClient, BrowserClient...) drop the
      // connection on abort; the rest just stop being awaited.
      response = await _client
          .send(http.AbortableRequest(
            'GET',
            // pathSegments escapes a `/` typed inside a city or street.
            Uri(
              scheme: 'https',
              host: _host,
              pathSegments: ['ws', ...segments, output.value],
            ),
            abortTrigger: abort.future,
          ))
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

    if (response.statusCode != 200) {
      throw CepException(
        'HTTP ${response.statusCode}: Failed to fetch ZIP code data',
        type: CepErrorType.http,
      );
    }

    try {
      // ViaCEP always answers in UTF-8, with or without a charset header.
      final body = utf8.decode(response.bodyBytes);
      return switch (output) {
        CepOutputFormat.json => jsonDecode(body),
        CepOutputFormat.xml => _xml(body),
      };
    } catch (e) {
      throw _invalidResponse(e);
    }
  }

  static Cep _cep(Object? data) {
    try {
      return Cep.fromJson(data as Map<String, dynamic>);
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

/// Deprecated alias of [FlutterCep2].
@Deprecated('Use FlutterCep2 instead')
// ignore: camel_case_types
typedef flutter_cep2 = FlutterCep2;

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

    final http.Response response;
    try {
      // shortcut: the timed-out request keeps running in the client, move to
      // http's AbortableRequest if hung requests ever pile up.
      response = await _client
          .get(Uri.https(_host, '/ws/$digits/${output.value}'))
          .timeout(timeout);
    } on TimeoutException {
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

    final Map<String, Object?> data;
    try {
      // ViaCEP always answers in UTF-8, with or without a charset header.
      final body = utf8.decode(response.bodyBytes);
      data = switch (output) {
        CepOutputFormat.json => jsonDecode(body) as Map<String, Object?>,
        CepOutputFormat.xml => _xmlFields(body),
      };
    } catch (e) {
      throw _invalidResponse(e);
    }

    // ViaCEP has sent `"erro": true` and, today, `"erro": "true"`.
    final erro = data['erro'];
    if (erro == true || erro == 'true') {
      throw const CepException(
        'ZIP code not found',
        type: CepErrorType.notFound,
      );
    }

    try {
      return Cep.fromJson(data);
    } catch (e) {
      throw _invalidResponse(e);
    }
  }

  /// Reads `<xmlcep><field>value</field>...</xmlcep>` into a map.
  static Map<String, String> _xmlFields(String body) {
    final root = XmlDocument.parse(body).rootElement;
    if (root.name.local != 'xmlcep') {
      throw FormatException('Unexpected root element <${root.name.local}>');
    }
    return {for (final e in root.childElements) e.name.local: e.innerText};
  }

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

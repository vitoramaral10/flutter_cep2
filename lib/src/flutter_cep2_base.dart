import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:xml2json/xml2json.dart';

/// A Brazilian ZIP code (CEP) lookup service using the ViaCEP API.
///
/// This class provides methods to search for Brazilian postal code information
/// using different output formats (JSON, XML).
///
/// Example usage:
/// ```dart
/// final cepService = FlutterCep2();
/// try {
///   final result = await cepService.search('01310-100');
///   print('Address: ${result.logradouro}');
/// } catch (e) {
///   print('Error: $e');
/// }
/// ```
class FlutterCep2 {
  /// The base URL for the ViaCEP API.
  static const String _baseUrl = 'https://viacep.com.br/ws/';

  /// HTTP client used for making requests.
  final http.Client _client;

  /// Creates a new instance of [FlutterCep2].
  ///
  /// Optionally accepts a custom HTTP [client] for testing purposes.
  FlutterCep2({http.Client? client}) : _client = client ?? http.Client();

  /// Searches for ZIP code information.
  ///
  /// [cep] The Brazilian ZIP code to search for (with or without formatting).
  /// [output] The desired output format ('json' or 'xml').
  /// Defaults to 'json'.
  ///
  /// Returns a [Cep] object containing the address information.
  ///
  /// Throws [CepException] if the ZIP code is invalid or if there's a
  /// network error.
  Future<Cep> search(
    String cep, {
    CepOutputFormat output = CepOutputFormat.json,
  }) async {
    final cleanedCep = _cleanCep(cep);
    if (!_isValidCep(cleanedCep)) {
      throw const CepException('Invalid ZIP code format');
    }

    final url = '$_baseUrl$cleanedCep/${output.value}';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw CepException(
          'HTTP ${response.statusCode}: Failed to fetch ZIP code data',
        );
      }

      return _parseResponse(response.body, output);
    } catch (e) {
      if (e is CepException) rethrow;
      throw CepException('Network error: ${e.toString()}');
    }
  }

  /// Cleans the ZIP code by removing non-numeric characters.
  String _cleanCep(String cep) {
    return cep.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Validates if the ZIP code has the correct format (8 digits).
  bool _isValidCep(String cep) {
    return RegExp(r'^\d{8}$').hasMatch(cep);
  }

  /// Parses the API response based on the output format.
  Cep _parseResponse(String body, CepOutputFormat output) {
    switch (output) {
      case CepOutputFormat.json:
        return _parseJsonResponse(body);
      case CepOutputFormat.xml:
        return _parseXmlResponse(body);
    }
  }

  /// Parses JSON response from the API.
  Cep _parseJsonResponse(String body) {
    final Map<String, dynamic> data = jsonDecode(body) as Map<String, dynamic>;

    if (data['erro'] == true) {
      throw const CepException('ZIP code not found');
    }

    return Cep.fromJson(data);
  }

  /// Parses XML response from the API.
  Cep _parseXmlResponse(String body) {
    final transformer = Xml2Json();
    transformer.parse(body);
    final jsonString = transformer.toParker();
    final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    final data = parsedJson['xmlcep'] as Map<String, dynamic>;

    if (data['erro'] == 'true') {
      throw const CepException('ZIP code not found');
    }

    return Cep.fromJson(data);
  }

  /// Closes the HTTP client.
  void dispose() {
    _client.close();
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

/// Represents Brazilian ZIP code (CEP) information.
///
/// This class contains all the address information returned by the ViaCEP API.
@immutable
class Cep {
  /// The ZIP code (CEP) in format XXXXX-XXX.
  final String cep;

  /// The street name (logradouro).
  final String logradouro;

  /// Additional address information (complemento).
  final String? complemento;

  /// The neighborhood (bairro).
  final String bairro;

  /// The city name (localidade).
  final String localidade;

  /// The state abbreviation (UF).
  final String uf;

  /// The postal unit (unidade).
  final String? unidade;

  /// The IBGE city code.
  final String ibge;

  /// The GIA code (São Paulo only).
  final String? gia;

  /// The area code (DDD).
  final String? ddd;

  /// The SIAF code.
  final String? siaf;

  /// Creates a new [Cep] instance.
  const Cep({
    required this.cep,
    required this.logradouro,
    this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.unidade,
    required this.ibge,
    this.gia,
    this.ddd,
    this.siaf,
  });

  /// Creates a [Cep] instance from a JSON map.
  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      unidade: json['unidade'] as String?,
      ibge: json['ibge'] as String? ?? '',
      gia: json['gia'] as String?,
      ddd: json['ddd'] as String?,
      siaf: json['siaf'] as String?,
    );
  }

  /// Converts this [Cep] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'unidade': unidade,
        'ibge': ibge,
        'gia': gia,
        'ddd': ddd,
        'siaf': siaf,
      };

  @override
  String toString() {
    return 'Cep(cep: $cep, logradouro: $logradouro, bairro: $bairro, '
        'localidade: $localidade, uf: $uf)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cep &&
        other.cep == cep &&
        other.logradouro == logradouro &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.localidade == localidade &&
        other.uf == uf &&
        other.unidade == unidade &&
        other.ibge == ibge &&
        other.gia == gia &&
        other.ddd == ddd &&
        other.siaf == siaf;
  }

  @override
  int get hashCode {
    return Object.hash(
      cep,
      logradouro,
      complemento,
      bairro,
      localidade,
      uf,
      unidade,
      ibge,
      gia,
      ddd,
      siaf,
    );
  }
}

/// Exception thrown when there's an error with ZIP code operations.
class CepException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [CepException] with the given [message].
  const CepException(this.message);

  @override
  String toString() => 'CepException: $message';
}

// Backward compatibility - deprecated classes
/// @deprecated Use FlutterCep2 instead
@Deprecated('Use FlutterCep2 instead')
// ignore: camel_case_types
typedef flutter_cep2 = FlutterCep2;

/// @deprecated Use Cep instead
@Deprecated('Use Cep instead')
// ignore: camel_case_types
typedef CEP = Cep;

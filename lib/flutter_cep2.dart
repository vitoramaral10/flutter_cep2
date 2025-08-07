/// A Brazilian ZIP code (CEP) lookup library for Dart and Flutter.
///
/// This library provides a simple way to lookup Brazilian postal code
/// information using the ViaCEP API. It supports multiple output formats
/// and provides proper error handling.
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_cep2/flutter_cep2.dart';
///
/// final cepService = FlutterCep2();
/// try {
///   final result = await cepService.search('01310-100');
///   print('Address: ${result.logradouro}, ' +
///         '${result.localidade} - ${result.uf}');
/// } catch (e) {
///   print('Error: $e');
/// }
/// ```
library flutter_cep2;

export 'src/flutter_cep2_base.dart';

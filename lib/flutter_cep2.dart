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
///   print('${result.logradouro}, ${result.localidade} - ${result.uf}');
/// } on CepException catch (e) {
///   print('Error: ${e.message}');
/// } finally {
///   cepService.dispose();
/// }
/// ```
library;

export 'src/flutter_cep2_base.dart';

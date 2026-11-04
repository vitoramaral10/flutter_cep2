/// A Brazilian ZIP code (CEP) lookup library for Dart and Flutter.
///
/// Looks up Brazilian postal codes with ViaCEP, optionally falling back to
/// BrasilAPI and OpenCEP and caching answers in memory.
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

export 'src/cep.dart';
export 'src/cep_exception.dart';
export 'src/cep_utils.dart' show cepState, formatCep, isValidCep;
export 'src/flutter_cep2.dart';

// ignore_for_file: avoid_print

import 'package:flutter_cep2/flutter_cep2.dart';

Future<void> main() async {
  // Create a new instance of the CEP service
  final cepService = FlutterCep2();

  // Example 1: Search with formatted CEP
  print('=== Example 1: Formatted CEP ===');
  await searchAndPrint(cepService, '01310-100');

  // Example 2: Search with unformatted CEP
  print('\n=== Example 2: Unformatted CEP ===');
  await searchAndPrint(cepService, '20040020');

  // Example 3: Error handling - Invalid CEP
  print('\n=== Example 3: Invalid CEP ===');
  await searchAndPrint(cepService, '00000000');

  // Example 4: Error handling - Malformed CEP
  print('\n=== Example 4: Malformed CEP ===');
  await searchAndPrint(cepService, '123');

  // Example 5: XML format
  print('\n=== Example 5: XML Format ===');
  await searchWithXml(cepService, '01310-100');

  // Don't forget to dispose the service when done
  cepService.dispose();
}

Future<void> searchAndPrint(FlutterCep2 service, String cep) async {
  try {
    final result = await service.search(cep);

    print('CEP: ${result.cep}');
    print('Logradouro: ${result.logradouro}');
    if (result.complemento?.isNotEmpty == true) {
      print('Complemento: ${result.complemento}');
    }
    print('Bairro: ${result.bairro}');
    print('Localidade: ${result.localidade}');
    print('UF: ${result.uf}');
    if (result.unidade?.isNotEmpty == true) {
      print('Unidade: ${result.unidade}');
    }
    print('IBGE: ${result.ibge}');
    if (result.gia?.isNotEmpty == true) {
      print('GIA: ${result.gia}');
    }
    if (result.ddd?.isNotEmpty == true) {
      print('DDD: ${result.ddd}');
    }
    if (result.siaf?.isNotEmpty == true) {
      print('SIAF: ${result.siaf}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> searchWithXml(FlutterCep2 service, String cep) async {
  try {
    final result = await service.search(
      cep,
      output: CepOutputFormat.xml,
    );

    print('XML search result:');
    print('Address: ${result.logradouro}, ${result.bairro}');
    print('City: ${result.localidade} - ${result.uf}');
    print('CEP: ${result.cep}');
  } catch (e) {
    print('Error with XML format: $e');
  }
}

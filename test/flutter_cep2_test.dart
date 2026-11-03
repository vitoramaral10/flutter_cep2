import 'dart:async';
import 'dart:convert';

import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

// Mock HTTP client for testing
class MockClient extends http.BaseClient {
  final Map<String, http.Response> responses = {};

  void addResponse(String url, http.Response response) {
    responses[url] = response;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = responses[request.url.toString()];
    if (response != null) {
      return http.StreamedResponse(
        Stream.fromIterable([response.bodyBytes]),
        response.statusCode,
        headers: response.headers,
      );
    }

    return http.StreamedResponse(
      Stream.fromIterable([]),
      404,
    );
  }

  bool closed = false;

  @override
  void close() => closed = true;
}

// Client whose request never answers, or fails before reaching the server.
class StuckClient extends http.BaseClient {
  final Object? error;

  StuckClient({this.error});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (error != null) return Future.error(error!);
    return Completer<http.StreamedResponse>().future;
  }
}

void main() {
  group('FlutterCep2', () {
    late MockClient mockClient;
    late FlutterCep2 cepService;

    setUp(() {
      mockClient = MockClient();
      cepService = FlutterCep2(client: mockClient);
    });

    group('search method', () {
      test('should return valid Cep for valid ZIP code', () async {
        // Arrange
        const validCep = '01310100';
        const expectedResponse = {
          'cep': '01310-100',
          'logradouro': 'Avenida Paulista',
          'complemento': 'lado ímpar',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'ibge': '3550308',
          'gia': '1004',
          'ddd': '11',
          'siaf': '7107'
        };

        mockClient.addResponse(
          'https://viacep.com.br/ws/$validCep/json',
          http.Response(jsonEncode(expectedResponse), 200),
        );

        // Act
        final result = await cepService.search(validCep);

        // Assert
        expect(result.cep, equals('01310-100'));
        expect(result.logradouro, equals('Avenida Paulista'));
        expect(result.bairro, equals('Bela Vista'));
        expect(result.localidade, equals('São Paulo'));
        expect(result.uf, equals('SP'));
      });

      test('should handle ZIP code with formatting', () async {
        // Arrange
        const formattedCep = '01310-100';
        const cleanedCep = '01310100';
        const expectedResponse = {
          'cep': '01310-100',
          'logradouro': 'Avenida Paulista',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'ibge': '3550308',
        };

        mockClient.addResponse(
          'https://viacep.com.br/ws/$cleanedCep/json',
          http.Response(jsonEncode(expectedResponse), 200),
        );

        // Act
        final result = await cepService.search(formattedCep);

        // Assert
        expect(result.cep, equals('01310-100'));
      });

      test('should throw CepException for invalid ZIP code format', () async {
        // Arrange
        const invalidCep = '123';

        // Act & Assert
        expect(
          () => cepService.search(invalidCep),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            'Invalid ZIP code format',
          )),
        );
      });

      test('should throw CepException for non-existent ZIP code', () async {
        // Arrange
        const nonExistentCep = '00000000';
        const errorResponse = {'erro': true};

        mockClient.addResponse(
          'https://viacep.com.br/ws/$nonExistentCep/json',
          http.Response(jsonEncode(errorResponse), 200),
        );

        // Act & Assert
        expect(
          () => cepService.search(nonExistentCep),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            'ZIP code not found',
          )),
        );
      });

      test('should throw CepException for HTTP error', () async {
        // Arrange
        const validCep = '01310100';

        mockClient.addResponse(
          'https://viacep.com.br/ws/$validCep/json',
          http.Response('Server Error', 500),
        );

        // Act & Assert
        expect(
          () => cepService.search(validCep),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            contains('HTTP 500'),
          )),
        );
      });

      test('should throw for non-existent ZIP code with erro as string',
          () async {
        // Current ViaCEP answer for a missing CEP
        mockClient.addResponse(
          'https://viacep.com.br/ws/99999999/json',
          http.Response('{\n  "erro": "true"\n}', 200),
        );

        expect(
          () => cepService.search('99999999'),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            'ZIP code not found',
          )),
        );
      });

      test('should throw for non-existent ZIP code in XML', () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/99999999/xml',
          http.Response(
            '<?xml version="1.0" encoding="UTF-8"?>\n'
            '<xmlcep>\n  <erro>true</erro>\n</xmlcep>',
            200,
          ),
        );

        expect(
          () => cepService.search('99999999', output: CepOutputFormat.xml),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            'ZIP code not found',
          )),
        );
      });

      test('should read estado, regiao and siafi from the current API',
          () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/01310100/json',
          http.Response.bytes(
            utf8.encode(jsonEncode({
              'cep': '01310-100',
              'logradouro': 'Avenida Paulista',
              'complemento': 'de 612 a 1510 - lado par',
              'unidade': '',
              'bairro': 'Bela Vista',
              'localidade': 'São Paulo',
              'uf': 'SP',
              'estado': 'São Paulo',
              'regiao': 'Sudeste',
              'ibge': '3550308',
              'gia': '1004',
              'ddd': '11',
              'siafi': '7107',
            })),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ),
        );

        final result = await cepService.search('01310100');

        expect(result.estado, 'São Paulo');
        expect(result.regiao, 'Sudeste');
        expect(result.siaf, '7107');
        expect(result.localidade, 'São Paulo');
      });

      test('should parse the current XML answer', () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/01310100/xml',
          http.Response.bytes(
            utf8.encode('''<?xml version="1.0" encoding="UTF-8"?>
<xmlcep>
  <cep>01310-100</cep>
  <logradouro>Avenida Paulista</logradouro>
  <complemento>de 612 a 1510 - lado par</complemento>
  <unidade></unidade>
  <bairro>Bela Vista</bairro>
  <localidade>São Paulo</localidade>
  <uf>SP</uf>
  <estado>São Paulo</estado>
  <regiao>Sudeste</regiao>
  <ibge>3550308</ibge>
  <gia>1004</gia>
  <ddd>11</ddd>
  <siafi>7107</siafi>
</xmlcep>'''),
            200,
            headers: {'content-type': 'application/xml; charset=utf-8'},
          ),
        );

        final result =
            await cepService.search('01310100', output: CepOutputFormat.xml);

        expect(result.ddd, '11');
        expect(result.ibge, '3550308');
        expect(result.siaf, '7107');
        expect(result.regiao, 'Sudeste');
        expect(result.localidade, 'São Paulo');
      });

      test('should report a malformed body as invalid response', () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/01310100/json',
          http.Response('<html>oops</html>', 200),
        );

        expect(
          () => cepService.search('01310100'),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            startsWith('Invalid response'),
          )),
        );
      });

      test('should time out', () async {
        final service = FlutterCep2(
          client: StuckClient(),
          timeout: const Duration(milliseconds: 10),
        );

        expect(
          () => service.search('01310100'),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            'Request timed out',
          )),
        );
      });

      test('should wrap connection failures as network error', () async {
        final service = FlutterCep2(
          client: StuckClient(error: http.ClientException('no route')),
        );

        expect(
          () => service.search('01310100'),
          throwsA(isA<CepException>().having(
            (e) => e.message,
            'message',
            startsWith('Network error'),
          )),
        );
      });

      test('dispose leaves an injected client open', () {
        cepService.dispose();
        expect(mockClient.closed, isFalse);
      });

      test('should work with XML output format', () async {
        // Arrange
        const validCep = '01310100';
        const xmlResponse = '''<?xml version="1.0" encoding="UTF-8"?>
          <xmlcep>
            <cep>01310-100</cep>
            <logradouro>Avenida Paulista</logradouro>
            <complemento>lado ímpar</complemento>
            <bairro>Bela Vista</bairro>
            <localidade>São Paulo</localidade>
            <uf>SP</uf>
            <ibge>3550308</ibge>
            <gia>1004</gia>
            <ddd>11</ddd>
            <siaf>7107</siaf>
          </xmlcep>''';

        mockClient.addResponse(
          'https://viacep.com.br/ws/$validCep/xml',
          http.Response(xmlResponse, 200),
        );

        // Act
        final result = await cepService.search(
          validCep,
          output: CepOutputFormat.xml,
        );

        // Assert
        expect(result.cep, equals('01310-100'));
        expect(result.logradouro, equals('Avenida Paulista'));
        expect(result.localidade, equals('São Paulo'));
        expect(result.uf, equals('SP'));
      });
    });

    group('Cep model', () {
      test('should create Cep from JSON correctly', () {
        // Arrange
        const json = {
          'cep': '01310-100',
          'logradouro': 'Avenida Paulista',
          'complemento': 'lado ímpar',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'ibge': '3550308',
          'gia': '1004',
          'ddd': '11',
          'siaf': '7107'
        };

        // Act
        final cep = Cep.fromJson(json);

        // Assert
        expect(cep.cep, equals('01310-100'));
        expect(cep.logradouro, equals('Avenida Paulista'));
        expect(cep.complemento, equals('lado ímpar'));
        expect(cep.bairro, equals('Bela Vista'));
        expect(cep.localidade, equals('São Paulo'));
        expect(cep.uf, equals('SP'));
        expect(cep.ibge, equals('3550308'));
        expect(cep.gia, equals('1004'));
        expect(cep.ddd, equals('11'));
        expect(cep.siaf, equals('7107'));
      });

      test('should convert Cep to JSON correctly', () {
        // Arrange
        const cep = Cep(
          cep: '01310-100',
          logradouro: 'Avenida Paulista',
          complemento: 'lado ímpar',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
          gia: '1004',
          ddd: '11',
          siaf: '7107',
        );

        // Act
        final json = cep.toJson();

        // Assert
        expect(json['cep'], equals('01310-100'));
        expect(json['logradouro'], equals('Avenida Paulista'));
        expect(json['complemento'], equals('lado ímpar'));
        expect(json['bairro'], equals('Bela Vista'));
        expect(json['localidade'], equals('São Paulo'));
        expect(json['uf'], equals('SP'));
        expect(json['ibge'], equals('3550308'));
        expect(json['gia'], equals('1004'));
        expect(json['ddd'], equals('11'));
        expect(json['siaf'], equals('7107'));
      });

      test('should handle null values correctly', () {
        // Arrange
        const json = {
          'cep': '01310-100',
          'logradouro': 'Avenida Paulista',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
          'ibge': '3550308',
        };

        // Act
        final cep = Cep.fromJson(json);

        // Assert
        expect(cep.complemento, isNull);
        expect(cep.unidade, isNull);
        expect(cep.gia, isNull);
        expect(cep.ddd, isNull);
        expect(cep.siaf, isNull);
      });

      test('should implement equality correctly', () {
        // Arrange
        const cep1 = Cep(
          cep: '01310-100',
          logradouro: 'Avenida Paulista',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
        );

        const cep2 = Cep(
          cep: '01310-100',
          logradouro: 'Avenida Paulista',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
        );

        const cep3 = Cep(
          cep: '01310-101',
          logradouro: 'Avenida Paulista',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
        );

        // Assert
        expect(cep1, equals(cep2));
        expect(cep1.hashCode, equals(cep2.hashCode));
        expect(cep1, isNot(equals(cep3)));
      });

      test('should have meaningful toString', () {
        // Arrange
        const cep = Cep(
          cep: '01310-100',
          logradouro: 'Avenida Paulista',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
        );

        // Act
        final string = cep.toString();

        // Assert
        expect(string, contains('01310-100'));
        expect(string, contains('Avenida Paulista'));
        expect(string, contains('Bela Vista'));
        expect(string, contains('São Paulo'));
        expect(string, contains('SP'));
      });
    });

    group('CepOutputFormat enum', () {
      test('should have correct values', () {
        expect(CepOutputFormat.json.value, equals('json'));
        expect(CepOutputFormat.xml.value, equals('xml'));
      });
    });

    group('CepException', () {
      test('should have meaningful toString', () {
        const exception = CepException('Test error');
        expect(exception.toString(), equals('CepException: Test error'));
      });
    });
  });
}

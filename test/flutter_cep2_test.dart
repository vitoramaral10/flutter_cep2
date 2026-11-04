import 'dart:async';
import 'dart:convert';

import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as testing;
import 'package:test/test.dart';

// A UTF-8 body with no charset header: the case where package:http would
// fall back to latin1.
http.Response utf8Response(String body, int statusCode) =>
    http.Response.bytes(utf8.encode(body), statusCode);

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

  /// Set when the request's abort trigger fires.
  bool aborted = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (error != null) return Future.error(error!);
    if (request case http.Abortable(:final abortTrigger?)) {
      abortTrigger.then((_) => aborted = true);
    }
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
          utf8Response(jsonEncode(expectedResponse), 200),
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
          utf8Response(jsonEncode(expectedResponse), 200),
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
          utf8Response(jsonEncode(errorResponse), 200),
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
          utf8Response('Server Error', 500),
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
          utf8Response('{\n  "erro": "true"\n}', 200),
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
          utf8Response(
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
          utf8Response('<html>oops</html>', 200),
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

      test('should reject an XML answer with an unexpected root', () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/01310100/xml',
          utf8Response('<html><cep>01310-100</cep></html>', 200),
        );

        expect(
          () => cepService.search('01310100', output: CepOutputFormat.xml),
          throwsA(isA<CepException>()
              .having((e) => e.type, 'type', CepErrorType.invalidResponse)),
        );
      });

      group('error type', () {
        Future<CepErrorType> typeOf(
          FlutterCep2 service, [
          String cep = '01310100',
        ]) async {
          try {
            await service.search(cep);
          } on CepException catch (e) {
            return e.type;
          }
          fail('search did not throw');
        }

        test('invalidFormat', () async {
          expect(await typeOf(cepService, '123'), CepErrorType.invalidFormat);
        });

        test('notFound', () async {
          mockClient.addResponse(
            'https://viacep.com.br/ws/01310100/json',
            utf8Response('{"erro": "true"}', 200),
          );
          expect(await typeOf(cepService), CepErrorType.notFound);
        });

        test('http', () async {
          mockClient.addResponse(
            'https://viacep.com.br/ws/01310100/json',
            utf8Response('Bad Request', 400),
          );
          expect(await typeOf(cepService), CepErrorType.http);
        });

        test('invalidResponse', () async {
          mockClient.addResponse(
            'https://viacep.com.br/ws/01310100/json',
            utf8Response('[1, 2]', 200),
          );
          expect(await typeOf(cepService), CepErrorType.invalidResponse);
        });

        test('invalidResponse for a field of the wrong type', () async {
          mockClient.addResponse(
            'https://viacep.com.br/ws/01310100/json',
            utf8Response('{"cep": 1310100}', 200),
          );
          expect(await typeOf(cepService), CepErrorType.invalidResponse);
        });

        test('timeout', () async {
          final client = StuckClient();
          final service = FlutterCep2(
            client: client,
            timeout: const Duration(milliseconds: 10),
          );
          expect(await typeOf(service), CepErrorType.timeout);
          await Future<void>.delayed(Duration.zero);
          expect(client.aborted, isTrue, reason: 'timeout aborts the request');
        });

        test('network', () async {
          final service = FlutterCep2(
            client: StuckClient(error: http.ClientException('no route')),
          );
          expect(await typeOf(service), CepErrorType.network);
        });

        test('unknown by default', () {
          expect(const CepException('x').type, CepErrorType.unknown);
        });
      });

      test('dispose leaves an injected client open', () {
        cepService.dispose();
        expect(mockClient.closed, isFalse);
      });

      test('dispose closes the client it created', () {
        expect(FlutterCep2().dispose, returnsNormally);
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
          utf8Response(xmlResponse, 200),
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

    group('searchAddress', () {
      const url = 'https://viacep.com.br/ws/RS/Porto%20Alegre/Domingos%20Jose';
      const item = {
        'cep': '91790-072',
        'logradouro': 'Rua Domingos José Poli',
        'bairro': 'Restinga',
        'localidade': 'Porto Alegre',
        'uf': 'RS',
        'ibge': '4314902',
        'siafi': '8801',
      };

      Future<CepErrorType> typeOf(Future<Object?> Function() call) async {
        try {
          await call();
        } on CepException catch (e) {
          return e.type;
        }
        fail('no CepException');
      }

      test('returns every match from JSON', () async {
        mockClient.addResponse(
          '$url/json',
          utf8Response(jsonEncode([item, item]), 200),
        );

        final result = await cepService.searchAddress(
          ' RS ',
          'Porto Alegre',
          'Domingos Jose',
        );

        expect(result, hasLength(2));
        expect(result.first.logradouro, 'Rua Domingos José Poli');
        expect(result.first.siaf, '8801');
      });

      test('returns every match from XML', () async {
        mockClient.addResponse(
          '$url/xml',
          utf8Response(
            '<?xml version="1.0" encoding="utf-8"?><xmlcep><enderecos>'
            '<endereco><cep>91790-072</cep><logradouro>Rua Domingos José Poli'
            '</logradouro><uf>RS</uf></endereco>'
            '<endereco><cep>90420-200</cep><uf>RS</uf></endereco>'
            '</enderecos></xmlcep>',
            200,
          ),
        );

        final result = await cepService.searchAddress(
          'RS',
          'Porto Alegre',
          'Domingos Jose',
          output: CepOutputFormat.xml,
        );

        expect(result.map((c) => c.cep), ['91790-072', '90420-200']);
        expect(result.first.logradouro, 'Rua Domingos José Poli');
      });

      test('no match is an empty list', () async {
        mockClient.addResponse('$url/json', utf8Response('[]', 200));
        mockClient.addResponse(
          '$url/xml',
          utf8Response('<xmlcep><enderecos/></xmlcep>', 200),
        );

        for (final output in CepOutputFormat.values) {
          expect(
            await cepService.searchAddress(
              'RS',
              'Porto Alegre',
              'Domingos Jose',
              output: output,
            ),
            isEmpty,
          );
        }
      });

      test('escapes a slash inside a segment', () async {
        mockClient.addResponse(
          'https://viacep.com.br/ws/RS/Porto%20Alegre/A%2FB/json',
          utf8Response('[]', 200),
        );
        expect(
          await cepService.searchAddress('RS', 'Porto Alegre', 'A/B'),
          isEmpty,
        );
      });

      test('rejects short input without a request', () async {
        for (final args in [
          ('R', 'Porto Alegre', 'Domingos'),
          ('R1', 'Porto Alegre', 'Domingos'),
          ('RS', 'Po', 'Domingos'),
          ('RS', 'Porto Alegre', ' Do '),
        ]) {
          expect(
            await typeOf(
              () => cepService.searchAddress(args.$1, args.$2, args.$3),
            ),
            CepErrorType.invalidFormat,
            reason: '$args',
          );
        }
      });

      test('an object instead of a list is invalidResponse', () async {
        mockClient.addResponse(
          '$url/json',
          utf8Response('{"erro": "true"}', 200),
        );
        expect(
          await typeOf(
            () =>
                cepService.searchAddress('RS', 'Porto Alegre', 'Domingos Jose'),
          ),
          CepErrorType.invalidResponse,
        );
      });

      test('an item that is not an object is invalidResponse', () async {
        mockClient.addResponse('$url/json', utf8Response('[1]', 200));
        expect(
          await typeOf(
            () =>
                cepService.searchAddress('RS', 'Porto Alegre', 'Domingos Jose'),
          ),
          CepErrorType.invalidResponse,
        );
      });

      test('HTTP 400 is http', () async {
        mockClient.addResponse('$url/json', utf8Response('', 400));
        expect(
          await typeOf(
            () =>
                cepService.searchAddress('RS', 'Porto Alegre', 'Domingos Jose'),
          ),
          CepErrorType.http,
        );
      });
    });

    group('providers', () {
      const viaCep = 'https://viacep.com.br/ws/01310100/json';
      const brasilApi = 'https://brasilapi.com.br/api/cep/v2/01310100';
      const openCep = 'https://opencep.com/v1/01310100';
      const viaCepBody =
          '{"cep": "01310-100", "logradouro": "Avenida Paulista",'
          ' "bairro": "Bela Vista", "localidade": "São Paulo", "uf": "SP",'
          ' "ibge": "3550308", "ddd": "11"}';
      const brasilApiBody = '{"cep": "01310100", "state": "SP",'
          ' "city": "São Paulo", "neighborhood": "Bela Vista",'
          ' "street": "Avenida Paulista", "service": "open-cep",'
          ' "ibge": {"city": "3550308", "state": "35"}, "location":'
          ' {"type": "Point", "coordinates":'
          ' {"longitude": "-46.6553299", "latitude": "-23.5617698"}}}';
      const openCepBody =
          '{"cep": "01310-100", "logradouro": "Avenida Paulista",'
          ' "complemento": "de 612 a 1510 - lado par", "bairro": "Bela Vista",'
          ' "localidade": "São Paulo", "uf": "SP", "estado": "São Paulo",'
          ' "regiao": "Sudeste", "ibge": "3550308"}';

      /// Answers each URL from [routes] (status, body); anything else is a
      /// connection error. Records every URL asked.
      (FlutterCep2, List<String>) serviceWith(
        Map<String, (int, String)> routes, {
        List<CepProvider> providers = CepProvider.values,
        Duration? cacheDuration,
      }) {
        final asked = <String>[];
        final client = testing.MockClient((request) async {
          final url = request.url.toString();
          asked.add(url);
          final route = routes[url];
          if (route == null) throw http.ClientException('down', request.url);
          return utf8Response(route.$2, route.$1);
        });
        return (
          FlutterCep2(
            client: client,
            providers: providers,
            cacheDuration: cacheDuration,
          ),
          asked,
        );
      }

      Future<CepErrorType> typeOf(Future<Object?> Function() call) async {
        try {
          await call();
        } on CepException catch (e) {
          return e.type;
        }
        fail('no CepException');
      }

      test('ViaCEP only by default', () {
        expect(FlutterCep2().providers, [CepProvider.viaCep]);
      });

      test('an empty list is rejected', () {
        expect(() => FlutterCep2(providers: []), throwsArgumentError);
      });

      test('BrasilAPI fields map to Cep', () async {
        final (service, _) = serviceWith(
          {brasilApi: (200, brasilApiBody)},
          providers: [CepProvider.brasilApi],
        );

        final cep = await service.search('01310-100');

        expect(cep.cep, '01310-100');
        expect(cep.logradouro, 'Avenida Paulista');
        expect(cep.bairro, 'Bela Vista');
        expect(cep.localidade, 'São Paulo');
        expect(cep.uf, 'SP');
        expect(cep.ibge, '3550308');
        expect(cep.latitude, -23.5617698);
        expect(cep.longitude, -46.6553299);
      });

      test('BrasilAPI without a usable location has no coordinates', () async {
        for (final location in [
          '',
          ', "location": {"type": "Point", "coordinates": {}}',
          ', "location": {"coordinates": {"latitude": "x", "longitude": "1"}}',
        ]) {
          final (service, _) = serviceWith(
            {
              brasilApi: (200, '{"cep": "01310100", "state": "SP"$location}'),
            },
            providers: [CepProvider.brasilApi],
          );
          final cep = await service.search('01310100');
          expect(cep.latitude, isNull, reason: location);
          expect(cep.longitude, isNull, reason: location);
          expect(cep.ibge, '');
        }
      });

      test('a BrasilAPI ibge without city is invalidResponse', () async {
        final (service, _) = serviceWith(
          {brasilApi: (200, '{"cep": "01310100", "ibge": {"state": "35"}}')},
          providers: [CepProvider.brasilApi],
        );
        expect(
          await typeOf(() => service.search('01310100')),
          CepErrorType.invalidResponse,
        );
      });

      test('OpenCEP fields map to Cep', () async {
        final (service, _) = serviceWith(
          {openCep: (200, openCepBody)},
          providers: [CepProvider.openCep],
        );

        final cep = await service.search('01310100');

        expect(cep.complemento, 'de 612 a 1510 - lado par');
        expect(cep.regiao, 'Sudeste');
        expect(cep.ibge, '3550308');
        expect(cep.latitude, isNull);
      });

      test('coordinates survive toJson and fromJson', () {
        const cep = Cep(
          cep: '01310-100',
          logradouro: 'Avenida Paulista',
          bairro: 'Bela Vista',
          localidade: 'São Paulo',
          uf: 'SP',
          ibge: '3550308',
          latitude: -23.56,
          longitude: -46.65,
        );
        expect(Cep.fromJson(cep.toJson()), cep);
        expect(cep, isNot(Cep.fromJson({...cep.toJson(), 'latitude': 0})));
        expect(
            const Cep(
                    cep: '',
                    logradouro: '',
                    bairro: '',
                    localidade: '',
                    uf: '',
                    ibge: '')
                .toJson(),
            isNot(contains('latitude')));
      });

      test('a 404 is notFound for BrasilAPI and OpenCEP', () async {
        for (final (provider, url) in [
          (CepProvider.brasilApi, brasilApi),
          (CepProvider.openCep, openCep),
        ]) {
          final (service, _) = serviceWith(
            {url: (404, '{"error": true}')},
            providers: [provider],
          );
          expect(
            await typeOf(() => service.search('01310100')),
            CepErrorType.notFound,
            reason: '$provider',
          );
        }
      });

      test('a BrasilAPI body of the wrong shape is invalidResponse', () async {
        final (service, _) = serviceWith(
          {brasilApi: (200, '[]')},
          providers: [CepProvider.brasilApi],
        );
        expect(
          await typeOf(() => service.search('01310100')),
          CepErrorType.invalidResponse,
        );
      });

      test('falls back when a provider is down', () async {
        final (service, asked) = serviceWith({brasilApi: (200, brasilApiBody)});

        final cep = await service.search('01310100');

        expect(cep.logradouro, 'Avenida Paulista');
        expect(asked, [viaCep, brasilApi]);
      });

      test('falls back when a provider does not know the CEP', () async {
        final (service, asked) = serviceWith({
          viaCep: (200, '{"erro": "true"}'),
          brasilApi: (500, ''),
          openCep: (200, openCepBody),
        });

        final cep = await service.search('01310100');

        expect(cep.regiao, 'Sudeste');
        expect(asked, [viaCep, brasilApi, openCep]);
      });

      test('stops at the first answer', () async {
        final (service, asked) = serviceWith({viaCep: (200, viaCepBody)});

        expect((await service.search('01310100')).ddd, '11');
        expect(asked, [viaCep]);
      });

      test('notFound wins when every provider fails', () async {
        final (service, _) = serviceWith({brasilApi: (404, '')});
        expect(
          await typeOf(() => service.search('01310100')),
          CepErrorType.notFound,
        );
      });

      test('otherwise the last error is thrown', () async {
        final (service, _) = serviceWith({openCep: (503, '')});
        expect(
          await typeOf(() => service.search('01310100')),
          CepErrorType.http,
        );
      });

      test('an invalid CEP asks nobody', () async {
        final (service, asked) = serviceWith({});
        expect(
          await typeOf(() => service.search('123')),
          CepErrorType.invalidFormat,
        );
        expect(asked, isEmpty);
      });
    });

    group('cache', () {
      const viaCep = 'https://viacep.com.br/ws/01310100';
      const address = 'https://viacep.com.br/ws/SP/Sao%20Paulo/Paulista';
      const body = '{"cep": "01310-100", "logradouro": "Avenida Paulista",'
          ' "bairro": "Bela Vista", "localidade": "São Paulo", "uf": "SP",'
          ' "ibge": "3550308"}';

      (FlutterCep2, List<String>) serviceWith(
        Duration? cacheDuration, {
        int status = 200,
      }) {
        final asked = <String>[];
        final client = testing.MockClient((request) async {
          final url = request.url.toString();
          asked.add(url);
          if (url.startsWith(address)) {
            return utf8Response('[$body, $body]', status);
          }
          if (url == '$viaCep/xml') {
            return utf8Response(
                '<xmlcep><cep>01310-100</cep></xmlcep>', status);
          }
          return utf8Response(body, status);
        });
        return (
          FlutterCep2(client: client, cacheDuration: cacheDuration),
          asked,
        );
      }

      test('off by default', () async {
        final (service, asked) = serviceWith(null);
        await service.search('01310100');
        await service.search('01310100');
        expect(asked, hasLength(2));
      });

      test('a repeated lookup skips the network', () async {
        final (service, asked) = serviceWith(const Duration(minutes: 1));

        final first = await service.search('01310-100');
        final second = await service.search('01310100');

        expect(second, first);
        expect(asked, ['$viaCep/json']);
      });

      test('the format does not split the cache', () async {
        final (service, asked) = serviceWith(const Duration(minutes: 1));
        await service.search('01310100');
        await service.search('01310100', output: CepOutputFormat.xml);
        expect(asked, ['$viaCep/json']);
      });

      test('an answer expires after cacheDuration', () async {
        final (service, asked) = serviceWith(const Duration(milliseconds: 20));
        await service.search('01310100');
        await Future<void>.delayed(const Duration(milliseconds: 40));
        await service.search('01310100');
        expect(asked, hasLength(2));
      });

      test('errors are not cached', () async {
        final (service, asked) = serviceWith(
          const Duration(minutes: 1),
          status: 500,
        );
        for (var i = 0; i < 2; i++) {
          await expectLater(
            service.search('01310100'),
            throwsA(isA<CepException>()),
          );
        }
        expect(asked, hasLength(2));
      });

      test('address search is cached, case-insensitively', () async {
        final (service, asked) = serviceWith(const Duration(minutes: 1));

        final first =
            await service.searchAddress('SP', 'Sao Paulo', 'Paulista');
        final second =
            await service.searchAddress('sp', 'sao paulo', 'PAULISTA');

        expect(second, first);
        expect(asked, ['$address/json']);
      });

      test('a cached address list can be changed by the caller', () async {
        final (service, _) = serviceWith(const Duration(minutes: 1));

        final first = await service.searchAddress('SP', 'Sao Paulo', 'Paulista')
          ..clear();
        final second =
            await service.searchAddress('SP', 'Sao Paulo', 'Paulista')
              ..removeLast();

        expect(first, isEmpty);
        expect(second, hasLength(1));
        expect(
          await service.searchAddress('SP', 'Sao Paulo', 'Paulista'),
          hasLength(2),
        );
      });

      test('keeps at most 1000 answers, dropping the oldest', () async {
        final (service, asked) = serviceWith(const Duration(minutes: 1));
        for (var i = 0; i <= 1000; i++) {
          await service.search(i.toString().padLeft(8, '0'));
        }
        asked.clear();

        await service.search('00001000'); // newest: still cached
        await service.search('00000000'); // oldest: dropped

        expect(asked, ['https://viacep.com.br/ws/00000000/json']);
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

        // Built at runtime: two equal const values would be one instance.
        final cep2 = Cep.fromJson(cep1.toJson());

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

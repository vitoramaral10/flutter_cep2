# flutter_cep2

[![pub package](https://img.shields.io/pub/v/flutter_cep2.svg)](https://pub.dev/packages/flutter_cep2)
[![pub points](https://img.shields.io/pub/points/flutter_cep2)](https://pub.dev/packages/flutter_cep2/score)
[![Tests](https://github.com/vitoramaral10/flutter_cep2/actions/workflows/test.yml/badge.svg)](https://github.com/vitoramaral10/flutter_cep2/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/vitoramaral10/flutter_cep2/branch/main/graph/badge.svg)](https://codecov.io/gh/vitoramaral10/flutter_cep2)
[![license](https://img.shields.io/badge/license-LGPL--2.1-blue.svg)](LICENSE)

Brazilian ZIP code (CEP) lookup for Dart and Flutter, powered by
[ViaCEP](https://viacep.com.br/).

- Accepts CEPs in any format (`01310-100`, `01310100`, `01.310-100`)
- JSON or XML from the API, the same typed `Cep` either way
- One exception, `CepException`, with a `CepErrorType` for every failure
- Pure Dart: Android, iOS, web, Windows, macOS and Linux

## Installation

```bash
dart pub add flutter_cep2
```

Requires Dart 3.0 or later (Flutter 3.10 or later).

## Usage

```dart
import 'package:flutter_cep2/flutter_cep2.dart';

Future<void> main() async {
  final cep = FlutterCep2();
  try {
    final result = await cep.search('01310-100');
    print('${result.logradouro}, ${result.bairro} - ${result.localidade}/${result.uf}');
  } on CepException catch (e) {
    print('CEP error: ${e.message}');
  } finally {
    cep.dispose();
  }
}
```

Keep one `FlutterCep2` for as long as you need it and call `dispose()` at the
end; it reuses the same HTTP connection.

### XML output

```dart
await cep.search('01310-100', output: CepOutputFormat.xml);
```

### Search by address

```dart
final matches = await cep.searchAddress('RS', 'Porto Alegre', 'Domingos Jose');
for (final m in matches) {
  print('${m.cep} ${m.logradouro}');
}
```

`uf` is the two-letter state; `city` and `street` need at least 3 characters.
ViaCEP returns up to 50 matches; none is an empty list.

### Errors

`search` and `searchAddress` throw `CepException`. Branch on `type`; `message` is for logs.

| `type`            | `message`                                     | When                              |
|-------------------|-----------------------------------------------|-----------------------------------|
| `invalidFormat`   | `Invalid ZIP code format`                     | The input does not have 8 digits  |
| `invalidFormat`   | `Invalid address: ...`                        | `searchAddress` input too short   |
| `notFound`        | `ZIP code not found`                          | ViaCEP has no address for the CEP |
| `http`            | `HTTP <code>: Failed to fetch ZIP code data`  | ViaCEP answered with a non-200    |
| `timeout`         | `Request timed out`                           | No answer within `timeout`        |
| `network`         | `Network error: ...`                          | The request could not be sent     |
| `invalidResponse` | `Invalid response: ...`                       | The body could not be parsed      |

```dart
try {
  await cep.search(input);
} on CepException catch (e) {
  switch (e.type) {
    case CepErrorType.invalidFormat:
    case CepErrorType.notFound:
      showFieldError('Check the CEP');
    default:
      showRetry();
  }
}
```

The format is checked before any request, so invalid input never reaches the
network.

### Testing your code

Pass your own `http.Client`, for example `MockClient` from `package:http/testing.dart`:

```dart
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final client = MockClient((request) async => http.Response(
      '{"cep": "01310-100", "logradouro": "Avenida Paulista", "bairro": "Bela Vista", '
      '"localidade": "São Paulo", "uf": "SP", "ibge": "3550308"}',
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ));
final cep = FlutterCep2(client: client);
```

A client you pass in stays open after `dispose()`; closing it is up to you.

## API

### `FlutterCep2({http.Client? client, Duration timeout = const Duration(seconds: 10)})`

Creates the service. `client` replaces the internal HTTP client; `timeout`
limits each request and aborts it when it runs out (on clients that support
aborting, such as the default one).

### `Future<Cep> search(String cep, {CepOutputFormat output = CepOutputFormat.json})`

Looks up the CEP and returns its address. Throws `CepException` (see
[Errors](#errors)). The answer is read as UTF-8, as ViaCEP sends it, even when
a proxy drops the charset header.

### `Future<List<Cep>> searchAddress(String uf, String city, String street, {CepOutputFormat output = CepOutputFormat.json})`

Lists the CEPs whose street matches `street` in `city`/`uf`. Returns an empty
list when nothing matches. Throws `CepException` (see [Errors](#errors)).

### `void dispose()`

Closes the HTTP client the service created. A client passed to the constructor
is left open.

### `Cep`

| Property      | Type      | Description                            |
|---------------|-----------|----------------------------------------|
| `cep`         | `String`  | Postal code in `XXXXX-XXX` format      |
| `logradouro`  | `String`  | Street name                            |
| `complemento` | `String?` | Extra address info                     |
| `bairro`      | `String`  | Neighborhood                           |
| `localidade`  | `String`  | City                                   |
| `uf`          | `String`  | State abbreviation (SP, RJ, ...)       |
| `estado`      | `String?` | State name (São Paulo, ...)            |
| `regiao`      | `String?` | Region (Sudeste, ...)                  |
| `unidade`     | `String?` | Postal unit                            |
| `ibge`        | `String`  | IBGE municipality code                 |
| `gia`         | `String?` | GIA code (São Paulo only)              |
| `ddd`         | `String?` | Area code                              |
| `siaf`        | `String?` | SIAFI code (`siafi` in the API)        |

`Cep` is immutable, compares by value and converts with `Cep.fromJson` and
`toJson()`.

## About ViaCEP

ViaCEP is a free public service, not run by this package. It asks clients not
to send bulk lookups; heavy use may get your IP blocked. Cache results you look
up often.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Bug reports and pull requests are welcome.

## License

GNU Lesser General Public License v2.1. See [LICENSE](LICENSE).

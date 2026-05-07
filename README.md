# flutter_cep2

[![pub package](https://img.shields.io/pub/v/flutter_cep2.svg)](https://pub.dev/packages/flutter_cep2)
[![pub points](https://img.shields.io/pub/points/flutter_cep2)](https://pub.dev/packages/flutter_cep2/score)
[![Tests](https://github.com/vitoramaral10/flutter_cep2/actions/workflows/test.yml/badge.svg)](https://github.com/vitoramaral10/flutter_cep2/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/vitoramaral10/flutter_cep2/branch/main/graph/badge.svg)](https://codecov.io/gh/vitoramaral10/flutter_cep2)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Brazilian ZIP code (CEP) lookup library for Dart and Flutter, powered by [ViaCEP](https://viacep.com.br/).

- Accepts CEPs in any format (`01310-100`, `01310100`, `01.310-100`)
- JSON or XML output
- Null-safe, well tested
- Pure Dart — works on every platform

## Installation

```yaml
dependencies:
  flutter_cep2: ^1.0.2
```

```bash
dart pub get
```

## Usage

```dart
import 'package:flutter_cep2/flutter_cep2.dart';

Future<void> main() async {
  final cep = FlutterCep2();
  try {
    final result = await cep.search('01310-100');
    print('${result.logradouro}, ${result.bairro} — ${result.localidade}/${result.uf}');
  } on CepException catch (e) {
    print('CEP error: ${e.message}');
  } finally {
    cep.dispose();
  }
}
```

### XML output

```dart
await cep.search('01310-100', output: CepOutputFormat.xml);
```

## API

### `FlutterCep2({http.Client? client})`
Creates the service. Accepts an optional `http.Client` (useful for tests).

### `Future<Cep> search(String cep, {CepOutputFormat output = CepOutputFormat.json})`
Looks up the CEP. Throws `CepException` for invalid or not-found codes.

### `void dispose()`
Closes the underlying HTTP client.

### `Cep`

| Property      | Type      | Description                            |
|---------------|-----------|----------------------------------------|
| `cep`         | `String`  | Postal code in `XXXXX-XXX` format      |
| `logradouro`  | `String`  | Street/road name                       |
| `complemento` | `String?` | Extra address info                     |
| `bairro`      | `String`  | Neighborhood                           |
| `localidade`  | `String`  | City                                   |
| `uf`          | `String`  | State (SP, RJ, ...)                    |
| `unidade`     | `String?` | Postal unit                            |
| `ibge`        | `String`  | IBGE municipality code                 |
| `gia`         | `String?` | GIA code (São Paulo)                   |
| `ddd`         | `String?` | Area code                              |
| `siaf`        | `String?` | SIAF code                              |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Bug reports and PRs welcome.

## License

MIT — see [LICENSE](LICENSE).

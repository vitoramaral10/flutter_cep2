# flutter_cep2 - Brazilian CEP Lookup Library

[![pub package](https://img.shields.io/pub/v/flutter_cep2.svg)](https://pub.dev/packages/flutter_cep2)
[![pub points](https://img.shields.io/pub/points/flutter_cep2)](https://pub.dev/packages/flutter_cep2/score)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/vitoramaral10/flutter_cep2/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/vitoramaral10/flutter_cep2)](https://github.com/vitoramaral10/flutter_cep2)

The most complete and reliable Brazilian ZIP code (CEP) lookup library for Dart and Flutter applications. Instantly search postal codes and get detailed address information with full support for formatting, error handling, and multiple output formats.

**Perfect for:** Address forms, delivery apps, e-commerce checkout, address validation, location services, and any Flutter/Dart application that needs Brazilian postal code lookups (busca CEP, endereço Brasil, código postal).

## ⭐ Features

- ✅ **Zero-Configuration**: Works out of the box with no setup required
- ✅ **Flexible Input**: Accepts CEPs in any format (01310-100, 01310100, 01.310-100)
- ✅ **Multiple Output Formats**: JSON and XML response formats for different use cases
- ✅ **Comprehensive Error Handling**: Custom exceptions with meaningful error messages
- ✅ **Full Null Safety**: Production-ready with complete null safety support
- ✅ **Well Tested**: Extensive test coverage ensuring reliability
- ✅ **Cross-Platform**: Android, iOS, Web, Windows, macOS, and Linux
- ✅ **Lightning Fast**: Optimized for quick CEP lookups with minimal dependencies
- ✅ **Lightweight**: Small package size with only essential dependencies
- ✅ **ViaCEP API**: Leverages the reliable ViaCEP service for accurate Brazilian postal data

## 🚀 Quick Start

### Installation

Add **flutter_cep2** to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_cep2: ^1.0.0
```

Then get dependencies:

```bash
dart pub get
# or
flutter pub get
```

### Basic Import

```dart
import 'package:flutter_cep2/flutter_cep2.dart';
```

**Alternative names you might search for:**
- CEP lookup Dart
- Busca CEP Flutter
- Consulta CEP Brasil
- Endereço CEP Dart
- Código postal Brasil
- Address lookup Flutter

## 📖 Usage Guide

### Basic CEP Lookup

```dart
import 'package:flutter_cep2/flutter_cep2.dart';

Future<void> main() async {
  final cepService = FlutterCep2();
  
  try {
    // Search for a Brazilian CEP (busca CEP Brasil)
    final result = await cepService.search('01310-100');
    
    print('📍 CEP: ${result.cep}');
    print('🏠 Address (Logradouro): ${result.logradouro}');
    print('🏘️ Neighborhood (Bairro): ${result.bairro}');
    print('🏙️ City (Localidade): ${result.localidade}');
    print('📍 State (UF): ${result.uf}');
  } catch (e) {
    print('Error: $e');
  } finally {
    // Always dispose the service
    cepService.dispose();
  }
}
```

### Flexible CEP Input Formats

The library automatically handles multiple CEP formats - no need to validate or format manually:

```dart
final cepService = FlutterCep2();

// All formats are supported (consulta CEP em qualquer formato):
await cepService.search('01310-100');   // Standard format ✅
await cepService.search('01310100');    // Without separator ✅
await cepService.search('01.310-100');  // Alternative format ✅
```

### XML Output Format

Get CEP data in XML format for integration with legacy systems:

```dart
final cepService = FlutterCep2();

final result = await cepService.search(
  '01310-100',
  output: CepOutputFormat.xml,  // XML response format
);
```

### Error Handling & Invalid CEPs

Handle errors gracefully with custom exception types:

```dart
final cepService = FlutterCep2();

try {
  final result = await cepService.search('00000-000');
} on CepException catch (e) {
  // Handle CEP-specific errors (CEP inválido, not found, etc.)
  print('CEP Error: ${e.message}');
} catch (e) {
  // Handle other errors (network, parsing, etc.)
  print('Unexpected error: $e');
} finally {
  cepService.dispose();
}
```

## 📚 Complete API Reference

### FlutterCep2 Class

Main service class for Brazilian CEP lookups and address searches.

#### Constructor
```dart
FlutterCep2({http.Client? client})
```
- Creates a new CEP service instance
- **Optional:** Accepts a custom HTTP client for testing/custom configuration

#### Methods
```dart
Future<Cep> search(String cep, {CepOutputFormat output = CepOutputFormat.json})
```
- **Searches for ZIP code information** (busca CEP Brasil)
- Accepts formatted or unformatted CEP strings
- Returns `Cep` object with complete address data
- Throws `CepException` for invalid or not-found CEPs

```dart
void dispose()
```
- **Closes the HTTP client** and releases resources
- Always call this when done with the service

### Cep Model Class

Represents complete Brazilian postal code and address information.

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `cep` | `String` | ZIP code in XXXXX-XXX format |
| `logradouro` | `String` | Street/Road name (rua, avenida, etc.) |
| `complemento` | `String?` | Additional address info (apt, suite, etc.) |
| `bairro` | `String` | Neighborhood name (neighborhood/district) |
| `localidade` | `String` | City/Municipality name |
| `uf` | `String` | State abbreviation (SP, RJ, MG, etc.) |
| `unidade` | `String?` | Postal unit identifier |
| `ibge` | `String` | IBGE municipality code |
| `gia` | `String?` | GIA code (São Paulo only) |
| `ddd` | `String?` | Area code / Phone DDD |
| `siaf` | `String?` | SIAF code |

### CepOutputFormat Enum

Output format options for CEP search results.

```dart
enum CepOutputFormat {
  json,  // JSON format (default) - most common
  xml,   // XML format - for legacy system integration
}
```

### CepException Class

Custom exception for CEP-related errors.

```dart
class CepException implements Exception {
  final String message;  // Error description (CEP inválido, not found, etc.)
  
  CepException(this.message);
}
```

## 💡 Real-World Examples

### 1️⃣ Flutter Address Form Widget

Complete example for address lookup in forms (address autocomplete, delivery form, checkout):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_cep2/flutter_cep2.dart';

class CepLookupWidget extends StatefulWidget {
  @override
  _CepLookupWidgetState createState() => _CepLookupWidgetState();
}

class _CepLookupWidgetState extends State<CepLookupWidget> {
  final _cepService = FlutterCep2();
  final _controller = TextEditingController();
  Cep? _result;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _cepService.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchCep() async {
    setState(() {
      _result = null;
      _error = null;
      _loading = true;
    });

    try {
      final result = await _cepService.search(_controller.text);
      setState(() {
        _result = result;
        _loading = false;
      });
    } on CepException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'CEP / Código Postal',
            hintText: '01310-100',
            suffixIcon: _loading 
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchCep,
                ),
          ),
        ),
        if (_result != null) ...[
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Endereço Encontrado',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text('📍 ${_result!.logradouro}'),
                  Text('🏘️ ${_result!.bairro}'),
                  Text('🏙️ ${_result!.localidade} - ${_result!.uf}'),
                  if (_result!.complemento != null)
                    Text('ℹ️ ${_result!.complemento}'),
                ],
              ),
            ),
          ),
        ],
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Erro: $_error',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
```

### 2️⃣ E-commerce Checkout (Delivery Address)

```dart
// Get address from CEP and prefill form
final cepService = FlutterCep2();
final cepData = await cepService.search(userInputCep);

addressForm.logradouro = cepData.logradouro;
addressForm.city = cepData.localidade;
addressForm.state = cepData.uf;
addressForm.neighborhood = cepData.bairro;

cepService.dispose();
```

### 3️⃣ Address Validation (validate if CEP exists)

```dart
bool isValidBrazilianCep(String cep) {
  final cepService = FlutterCep2();
  
  try {
    await cepService.search(cep);
    cepService.dispose();
    return true;
  } on CepException {
    cepService.dispose();
    return false;
  }
}
```

## ✅ Testing

The package includes comprehensive test coverage. Run tests with:

```bash
dart test
# or for Flutter projects
flutter test
```

## 🤝 Contributing

Contributions are welcome! Help improve this CEP lookup library:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests for new features
5. Submit a Pull Request with appropriate labels (`feature`, `fix`, `docs`, etc.)

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/vitoramaral10/flutter_cep2.git
cd flutter_cep2

# Install dependencies
dart pub get

# Setup Git hooks (validates commit messages)
bash scripts/setup-hooks.sh

# Run tests
dart test

# Format code
dart format .
```

### Commit Message Format

This project uses **Conventional Commits** to maintain a clean history and enable automated versioning.

```
type(scope?): subject
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`

**Examples**:
- `feat(api): add new CEP search method`
- `fix: correct validation logic`
- `docs: update README examples`

See [COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md) for detailed guidelines.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history, new features, and bug fixes.

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits & Attribution

- **API Provider:** [ViaCEP](https://viacep.com.br/) - Reliable Brazilian postal code database
- **Author:** [Vitor Amaral](https://github.com/vitoramaral10)
- **Support this project:** [GitHub Sponsors](https://github.com/sponsors/vitoramaral10)

## 💬 Support & Issues

Have questions or found a bug?
- **Report Issues:** [GitHub Issues](https://github.com/vitoramaral10/flutter_cep2/issues)
- **Start a Discussion:** [GitHub Discussions](https://github.com/vitoramaral10/flutter_cep2/discussions)

## 🔗 Related Resources

- **Flutter:** [flutter.dev](https://flutter.dev)
- **Dart:** [dart.dev](https://dart.dev)
- **Pub.dev Package:** [flutter_cep2](https://pub.dev/packages/flutter_cep2)
- **GitHub Repository:** [vitoramaral10/flutter_cep2](https://github.com/vitoramaral10/flutter_cep2)

---

**Made with ❤️ in Brazil 🇧🇷**

> **Search keywords:** Busca CEP Flutter, Endereço Brasil Dart, Código Postal CEP, Address Lookup Flutter, Brazilian ZIP Code, Consulta CEP, ViaCEP Flutter
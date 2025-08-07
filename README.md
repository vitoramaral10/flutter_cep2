# flutter_cep2

[![pub package](https://img.shields.io/pub/v/flutter_cep2.svg)](https://pub.dev/packages/flutter_cep2)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/vitoramaral10/flutter_cep2/blob/main/LICENSE)

A Brazilian ZIP code (CEP) lookup library for Dart and Flutter applications. This package provides easy access to Brazilian postal code information using the ViaCEP API.

## Features

- ✅ **Easy to use**: Simple API for ZIP code lookup
- ✅ **Multiple formats**: Support for formatted (01310-100) and unformatted (01310100) ZIP codes
- ✅ **Output formats**: JSON and XML response formats
- ✅ **Error handling**: Comprehensive error handling with custom exceptions
- ✅ **Null safety**: Full null safety support
- ✅ **Well tested**: Comprehensive test coverage
- ✅ **Platform support**: Works on Android, iOS, Web, Windows, macOS, and Linux
- ✅ **Documentation**: Full API documentation

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_cep2: ^1.0.0
```

Then run:

```bash
dart pub get
```

### Import

```dart
import 'package:flutter_cep2/flutter_cep2.dart';
```

## Usage

### Basic Usage

```dart
import 'package:flutter_cep2/flutter_cep2.dart';

Future<void> main() async {
  final cepService = FlutterCep2();
  
  try {
    final result = await cepService.search('01310-100');
    
    print('CEP: ${result.cep}');
    print('Address: ${result.logradouro}');
    print('Neighborhood: ${result.bairro}');
    print('City: ${result.localidade}');
    print('State: ${result.uf}');
  } catch (e) {
    print('Error: $e');
  }
  
  // Don't forget to dispose
  cepService.dispose();
}
```

### Different Input Formats

The library accepts ZIP codes in various formats:

```dart
final cepService = FlutterCep2();

// All of these work:
await cepService.search('01310-100');  // Formatted
await cepService.search('01310100');   // Unformatted
await cepService.search('01.310-100'); // Alternative formatting
```

### XML Output Format

```dart
final result = await cepService.search(
  '01310-100',
  output: CepOutputFormat.xml,
);
```

### Error Handling

```dart
try {
  final result = await cepService.search('00000-000');
} on CepException catch (e) {
  print('CEP Error: ${e.message}');
} catch (e) {
  print('Other error: $e');
}
```

## API Reference

### FlutterCep2

Main service class for ZIP code operations.

#### Constructor
- `FlutterCep2({http.Client? client})` - Creates a new instance. Optionally accepts a custom HTTP client for testing.

#### Methods
- `Future<Cep> search(String cep, {CepOutputFormat output = CepOutputFormat.json})` - Searches for ZIP code information
- `void dispose()` - Closes the HTTP client

### Cep

Model class representing Brazilian ZIP code information.

#### Properties
- `String cep` - The ZIP code in format XXXXX-XXX
- `String logradouro` - Street name
- `String? complemento` - Additional address information
- `String bairro` - Neighborhood
- `String localidade` - City name
- `String uf` - State abbreviation
- `String? unidade` - Postal unit
- `String ibge` - IBGE city code
- `String? gia` - GIA code (São Paulo only)
- `String? ddd` - Area code
- `String? siaf` - SIAF code

### CepOutputFormat

Enum for output format options.

- `CepOutputFormat.json` - JSON format (default)
- `CepOutputFormat.xml` - XML format

### CepException

Exception thrown when there's an error with ZIP code operations.

- `String message` - The error message

## Examples

### Flutter App Example

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
    });

    try {
      final result = await _cepService.search(_controller.text);
      setState(() {
        _result = result;
      });
    } on CepException catch (e) {
      setState(() {
        _error = e.message;
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
            labelText: 'Enter CEP',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchCep,
            ),
          ),
        ),
        if (_result != null) ...[
          Text('Address: ${_result!.logradouro}'),
          Text('City: ${_result!.localidade} - ${_result!.uf}'),
        ],
        if (_error != null)
          Text('Error: $_error', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
```

## Testing

The package includes comprehensive tests. To run them:

```bash
dart test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- Uses the [ViaCEP](https://viacep.com.br/) API for ZIP code data
- Maintained by [Vitor Amaral](https://github.com/vitoramaral10)

## Support

If you have any issues or questions, please file them in the [issue tracker](https://github.com/vitoramaral10/flutter_cep2/issues).

---

Made with ❤️ in Brazil 🇧🇷
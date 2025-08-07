# Flutter CEP2 Example

This is a comprehensive example application demonstrating all the capabilities of the `flutter_cep2` package.

## Features Demonstrated

### 🔍 **CEP Search**
- Input field with validation and formatting
- Support for both formatted (01310-100) and unformatted (01310100) CEPs
- Real-time error handling and user feedback
- Loading states during API requests

### 📱 **User Interface**
- Modern Material Design 3 interface
- Responsive layout that works on all screen sizes
- Dark/light theme support
- Intuitive user experience with clear feedback

### 🎯 **Quick Examples**
- Pre-defined CEP examples for quick testing
- One-tap search for common Brazilian addresses
- Examples from major cities (São Paulo, Rio de Janeiro, Belo Horizonte, etc.)

### 📋 **Comprehensive Results Display**
- All address fields with proper labels and icons
- Copy-to-clipboard functionality for each field
- Selective text for easy copying
- Professional card-based layout

### ⚙️ **Output Formats**
- Toggle between JSON and XML formats
- Real-time format switching without losing data
- Demonstrates the flexibility of the flutter_cep2 package

### ✨ **Additional Features**
- Plugin features showcase
- Documentation links
- Error handling demonstrations
- Performance optimizations

## How to Run

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Testing

Run the widget tests:
```bash
flutter test
```

## Code Structure

- `lib/main.dart` - Main application with all demo features
- `test/widget_test.dart` - Widget tests for the example app
- `pubspec.yaml` - Dependencies and configuration

## API Usage Examples

The example demonstrates various ways to use the flutter_cep2 package:

### Basic Usage
```dart
final cepService = FlutterCep2();
final result = await cepService.search('01310-100');
```

### With Error Handling
```dart
try {
  final result = await cepService.search(cep);
  // Handle success
} on CepException catch (e) {
  // Handle CEP-specific errors
} catch (e) {
  // Handle other errors
}
```

### Different Output Formats
```dart
// JSON format (default)
final jsonResult = await cepService.search('01310-100');

// XML format
final xmlResult = await cepService.search(
  '01310-100',
  output: CepOutputFormat.xml,
);
```

### Resource Management
```dart
final cepService = FlutterCep2();
// Use the service...
cepService.dispose(); // Clean up resources
```

This example serves as both a demonstration and a reference implementation for integrating flutter_cep2 into your own Flutter applications.

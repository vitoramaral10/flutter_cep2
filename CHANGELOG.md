# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-11-03

### Fixed
- A missing CEP now throws `CepException('ZIP code not found')`: ViaCEP sends
  `"erro": "true"` as a string, which used to return an empty `Cep`.
- `siaf` is filled again: ViaCEP names the field `siafi`.
- A malformed body is reported as `Invalid response`, not `Network error`.
- `dispose()` no longer closes an `http.Client` passed to the constructor.

### Added
- `Cep.estado` and `Cep.regiao`, sent by ViaCEP.
- `timeout` in the constructor (10 seconds by default); a slow request throws
  `CepException('Request timed out')`.

### Changed
- Dependencies: `xml2json` ^6.2.9, `test` ^1.33.0; GitHub Actions updated.
- Example: `cupertino_icons` ^2.0.0, `url_launcher` ^6.3.3, `flutter_lints`
  ^6.0.0; shows state name and region.

## [1.0.2] - 2025-08-07

### 📖 Documentation
- Added comprehensive Code of Conduct (CODE_OF_CONDUCT.md)
- Added detailed Contributing Guidelines (CONTRIBUTING.md)
- Enhanced project documentation for better community engagement
- Improved development setup instructions
- Added GitHub Sponsors funding link for project support

## [1.0.1] - 2025-08-07

### 📖 Improved
- Enhanced example application to better demonstrate plugin usage
- Updated example UI and user experience for clearer functionality showcase
- Improved example code documentation and comments

## [1.0.0] - 2025-08-07

### ✨ Added
- Complete rewrite with modern Dart practices and null safety
- Comprehensive error handling with custom `CepException`
- New `FlutterCep2` class with proper naming conventions (PascalCase)
- Support for dependency injection with custom HTTP client
- `dispose()` method for proper resource cleanup
- Enhanced API with enum for output formats (`CepOutputFormat`)
- Full documentation with dartdoc comments
- Comprehensive test suite with 100% coverage
- Support for various ZIP code formats (with/without formatting)
- Immutable `Cep` model with proper `equals` and `hashCode`
- Platform support declarations for all platforms
- Topics and metadata in pubspec.yaml

### 🔧 Changed
- Updated minimum Dart SDK version to 2.17.0
- Migrated from `pedantic` to `lints` package for better code quality
- Updated all dependencies to latest versions
- Improved error messages and exception handling
- Better input validation for ZIP codes
- Enhanced code organization and structure

### 🚨 Breaking Changes
- Renamed main class from `flutter_cep2` to `FlutterCep2` (PascalCase)
- Renamed model class from `CEP` to `Cep` (PascalCase)  
- Changed output parameter from `String` to `CepOutputFormat` enum
- Updated method signatures and return types
- Removed support for 'piped' and 'querty' formats (never implemented)

### 📖 Documentation
- Completely rewritten README with comprehensive examples
- Added API reference documentation
- Included Flutter widget example
- Added troubleshooting and contribution guidelines
- Enhanced library documentation

### 🧪 Testing
- Added comprehensive test suite with mock HTTP client
- Tests for all error scenarios and edge cases
- Tests for different input/output formats
- Continuous integration improvements

## [0.0.13] - Previous Release

### Changed
- Update xml2json v5.3.2

## [0.0.12] - Previous Release

### Added
- Implementação do CI/CD

## [0.0.11] - Previous Release

### Changed
- Remoção de print

## [0.0.10] - Previous Release

### Changed
- Melhoria no Score

## [0.0.9] - Previous Release

### Changed
- Melhoria no Score

## [0.0.8] - Previous Release

### Changed
- Melhoria no README.md

## [0.0.7] - Previous Release

### Added
- Versão inicial, desenvolvido por Vitor Melo
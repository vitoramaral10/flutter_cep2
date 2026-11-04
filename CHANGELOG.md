# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-11-04

### Added
- `providers`: `search` can fall back to BrasilAPI and OpenCEP
  (`CepProvider`) when ViaCEP fails or does not know the CEP. ViaCEP alone is
  still the default.
- `cacheDuration`: keeps successful answers of `search` and `searchAddress` in
  memory (up to 1000), so repeated lookups skip the network. Off by default.
- `Cep.latitude` and `Cep.longitude`, filled by BrasilAPI (now queried on its
  v2 API) when it knows the point.
- Offline helpers: `isValidCep`, `formatCep` and `cepState`, which gives the
  state and region from the Correios CEP ranges with no request.

## [1.1.1] - 2026-11-04

### Changed
- README rewritten: banner, feature table, address search, error table, FAQ.
- The pub.dev page shows a screenshot of the example app.
- Example: field labels such as "Neighborhood" no longer break mid-word.
- CI: coverage reaches Codecov again (upload via OIDC), so the badge works.

## [1.1.0] - 2026-11-03

### Fixed
- A missing CEP now throws `CepException('ZIP code not found')`: ViaCEP sends
  `"erro": "true"` as a string, which used to return an empty `Cep`.
- `siaf` is filled again: ViaCEP names the field `siafi`.
- A malformed body is reported as `Invalid response`, not `Network error`.
- `dispose()` no longer closes an `http.Client` passed to the constructor.
- The README said MIT; the package is licensed under LGPL-2.1, as in `LICENSE`.
- Accented text (`São Paulo`) is no longer garbled when the answer comes
  without a charset header: the body is always read as UTF-8.

### Added
- `searchAddress(uf, city, street)`: lists the CEPs of a street, from ViaCEP's
  `/ws/UF/city/street/` search, in JSON or XML.
- `CepException.type` (`CepErrorType`), so callers can tell a missing CEP from
  a network failure without matching the message.
- `Cep.estado` and `Cep.regiao`, sent by ViaCEP.
- `timeout` in the constructor (10 seconds by default); a slow request throws
  `CepException('Request timed out')` and the request is aborted, so the
  connection does not stay open.

### Changed
- Minimum Dart SDK is declared as 3.0, the real minimum of the dependencies
  (it said 2.17).
- Dependency ranges: `http` ^1.5.0 (needed to abort a timed-out request),
  `meta` ^1.9.0.
- XML answers are read with `package:xml` directly instead of being converted
  to JSON text and decoded again; the `xml2json` dependency is gone. Empty XML
  fields (`<unidade></unidade>`) now come as `''`, the same as in JSON, instead
  of `null`.
- The library is split into `Cep`, `CepException` and `FlutterCep2` files; the
  public API and import are unchanged.
- Example: guards against updating the screen after it is closed; shows the
  state name and region.

## [1.0.2] - 2025-08-07

### Added
- Code of Conduct and contributing guide.
- GitHub Sponsors funding link.

## [1.0.1] - 2025-08-07

### Changed
- Reworked example app.

## [1.0.0] - 2025-08-07

Rewrite with null safety.

### Added
- `FlutterCep2` service with an injectable `http.Client` and `dispose()`.
- `CepOutputFormat` enum (JSON, XML).
- `CepException` for every failure.
- Immutable `Cep` model with value equality, `fromJson` and `toJson`.
- Accepts CEPs with or without formatting.
- API documentation and tests.

### Changed
- **Breaking:** `flutter_cep2` class renamed to `FlutterCep2` and `CEP` to
  `Cep` (the old names remain as deprecated aliases).
- **Breaking:** the output format is a `CepOutputFormat` instead of a `String`.
- Moved from `pedantic` to `lints`.

### Removed
- **Breaking:** the `piped` and `querty` formats, which never worked.

## [0.0.13]

### Changed
- Update xml2json v5.3.2

## [0.0.12]

### Added
- CI/CD

## [0.0.11]

### Changed
- Removed a debug print

## [0.0.10]

### Changed
- pub.dev score improvements

## [0.0.9]

### Changed
- pub.dev score improvements

## [0.0.8]

### Changed
- README improvements

## [0.0.7]

### Added
- First version
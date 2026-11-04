# flutter_cep2 example

<img src="../doc/images/example-app.webp" alt="Example app showing the address of CEP 01310-100" width="300">

A Flutter app that looks up CEPs with `flutter_cep2`: type a CEP or tap one of
the samples, pick JSON or XML, and see every field of the address with a copy
button.

## Run

```bash
cd example
flutter pub get
flutter run
```

## Test

```bash
flutter test
```

The code is in [`lib/main.dart`](lib/main.dart). The part that uses the package
is `_CepLookupWidgetState`: one `FlutterCep2` created with the state, `search`
in `_searchCep`, `CepException` shown to the user, and `dispose()` with the
widget.

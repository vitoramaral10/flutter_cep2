# flutter_cep2

The `flutter_cep2` Flutter package allows you to easily search all Brazilian zip code data in your Flutter app.

## Getting Started

For example, let's say you want to look up zip code 80215-901 in your Flutter app.

First, add the `flutter_cep2` package to your [pubspec dependencies](https://pub.dev/packages/flutter_cep2#-installing-tab-).

To import `flutter_cep2`:

```dart
import 'package:flutter_cep2/flutter_cep2.dart';
```

To use `flutter_cep2`:

```dart
  var CEP = flutter_cep2();

  try {
    var result = await CEP.search('80215-901');

    print('CEP: ' + result.cep);
    print('Logradouro: ' + result.logradouro);
    print('Complemento: ' + result.complemento!);
    print('Bairro: ' + result.bairro);
    print('Localidade: ' + result.localidade);
    print('UF: ' + result.uf);
    print('Unidade: ' + result.unidade!);
    print('IBGE ' + result.ibge);
    print('GIA: ' + result.gia!);
    print('DDD: ' + result.ddd!);
    print('SIAF: ' + result.siaf!);
  } catch (e) {
    print(e);
  }
}
```

## Features and Bugs

Please for feature and bug requests [issue tracker][tracker].

[tracker]: https://github.com/vitoramaral10/flutter_cep2/issues
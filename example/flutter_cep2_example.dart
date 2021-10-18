import 'package:flutter_cep2/flutter_cep2.dart';

void main() async {
  var CEP = flutter_cep2();

  try {
    var result = await CEP.search('12512170');
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

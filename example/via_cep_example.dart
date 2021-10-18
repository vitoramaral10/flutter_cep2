
import 'package:flutter_cep2/flutter_cep2.dart';

void main() async {
  var CEP = flutter_cep2();

  var result = await CEP.searchCEP('12512170', 'json', '');

  // Sucesso
  if (result.getResponse() == 200) {
    print('CEP: '+result.getCEP());
    print('Logradouro: '+result.getLogradouro());
    print('Complemento: '+result.getComplemento());
    print('Bairro: '+result.getBairro());
    print('Localidade: '+result.getLocalidade());
    print('UF: '+result.getUF());
    print('Unidade: '+result.getUnidade());
    print('IBGE '+result.getIBGE());
    print('GIA: '+result.getGIA());
  } else {
    print('Código de Retorno: '+result.getResponse().toString());
    print('Erro: '+result.getBody());
  }
}
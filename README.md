Package para integração com API ViaCEP (https://www.viacep.com.br). Se você estava procurando um webservice gratuito e de alto desempenho para consultar Códigos de Endereçamento Postal (CEP) do Brasil? Utilize o serviço, melhore a qualidade de suas aplicações e colabore para manter esta base de dados atualizada.

## Uso

Um simples exemplo de uso:

```dart
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
```

## Recursos

search - Método que realiza a consulta do CEP.

    Parâmetros: search(String cep, {String output})
        String CEP = cep (somente números, sem caracteres especiais e com 8 digitos)
        
        String output = Tipo de saída de dados, para retorno por meio de get() é indiferente ao usuário, porém para retorno do Body haverá diferenciação (padrão json).
            Opções: json
                    xml
                    piped (Não implementado)
                    querty (Não implementado)
                    
            Qualquer formato texto informado não reconhecido irá gerar uma exceção.

O retorno é a class CEP.

Para conhecer melhor o funcionamento acesse o site de origem da API (https://www.viacep.com.br)

## Funcionalidades e Bugs

Por favor para requisições de funcionalidades e bugs [issue tracker][tracker].

[tracker]: https://github.com/vitoramaral10/flutter_cep2/issues
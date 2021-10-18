import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class flutter_cep2 {
  final String _URLBase = 'https://viacep.com.br/ws/';

  Future<CEP> search(
    String cep, {
    String output = 'json',
    String sensitive = '',
  }) async {
    sensitive = sensitive.toString().toLowerCase().trim();

    // ignore: omit_local_variable_types
    String _URLAccess = _URLBase + cep + '/' + output;

    var response = await http.get(Uri.parse(_URLAccess));

    var statusCode = response.statusCode;
    var body = response.body;
    print(body);
    if (statusCode != 200) {
      throw Exception('Error connection');
    } else {
      switch (output) {
        case 'json':
          Map<String, dynamic> cepDecoded = jsonDecode(body);

          if (cepDecoded['erro'] == true) {
            throw Exception('Invalid number CEP');
          } else {
            return CEP.fromJson(cepDecoded);
          }
        case 'xml':
          var myTransformer = Xml2Json();

          String? content = body;

          myTransformer.parse(content);

          content = myTransformer.toParker();

          Map<String, dynamic> cepDecoded = jsonDecode(content)['xmlcep'];

          if (cepDecoded['erro'] == 'true') {
            throw Exception('Invalid number CEP');
          } else {
            return CEP.fromJson(jsonDecode(content)['xmlcep']);
          }
        case 'piped':
          //var text = body.split('|');
          throw Exception('Not Implemented');
        case 'querty':
          //var text = body.replaceAll('+', ' ').split('&');
          throw Exception('Not Implemented');
        default:
          throw Exception('Not Implemented');
      }
    }
  }
}

class CEP {
  final String cep;
  final String logradouro;
  final String? complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String? unidade;
  final String ibge;
  final String? gia;
  final String? ddd;
  final String? siaf;

  CEP(
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.unidade,
    this.ibge,
    this.gia,
    this.ddd,
    this.siaf,
  );

  CEP.fromJson(Map<String, dynamic> json)
      : cep = json['cep'],
        logradouro = json['logradouro'],
        complemento = json['complemento'],
        bairro = json['bairro'],
        localidade = json['localidade'],
        uf = json['uf'],
        unidade = json['unidade'],
        ibge = json['ibge'],
        gia = json['gia'],
        ddd = json['ddd'],
        siaf = json['siaf'];

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'unidade': unidade,
        'ibge': ibge,
        'gia': gia,
        'ddd': ddd,
        'siaf': siaf,
      };
}

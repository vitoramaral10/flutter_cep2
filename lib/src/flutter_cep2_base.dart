import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart' as xml;

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

    if (statusCode != 200) {
      throw Exception('Error connection');
    } else {
      switch (output) {
        case 'json':
          return CEP.fromJson(jsonDecode(body));
        case 'xml':
          // ignore: omit_local_variable_types
          xml.Xml2Json myTransformer = xml.Xml2Json();

          // ignore: omit_local_variable_types
          String? content = body;

          myTransformer.parse(content);

          content = myTransformer.toParker();

          return CEP.fromJson(jsonDecode(content)['xmlcep']);
        case 'piped':
          var text = body.split('|');
          throw Exception('Not Implemented');
        case 'querty':
          var text = body.replaceAll('+', ' ').split('&');
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
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String unidade;
  final String ibge;
  final String gia;

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
        gia = json['gia'];

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
      };
}

import 'dart:convert';

import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/cep.dart';

class FlutterCep2 {
  static Future<Cep> search(
    String cep, {
    String output = 'json',
  }) async {
    String urlAccess = '${Constants.urlViaCep}$cep/$output';

    var response = await http.get(Uri.parse(urlAccess));

    var statusCode = response.statusCode;
    var body = response.body;

    if (statusCode != 200) {
      throw Exception('Error connection');
    } else {
      switch (output) {
        case 'json':
          Map<String, dynamic> cepDecoded = jsonDecode(body);

          if (cepDecoded['erro'] == true) {
            throw Exception('Invalid number CEP');
          } else {
            return Cep.fromJson(cepDecoded);
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
            return Cep.fromJson(jsonDecode(content)['xmlcep']);
          }
        case 'piped':
          throw Exception('Not Implemented');
        case 'querty':
          throw Exception('Not Implemented');
        default:
          throw Exception('Not Implemented');
      }
    }
  }
}

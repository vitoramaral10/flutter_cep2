class Cep {
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

  Cep({
    required this.cep,
    required this.logradouro,
    this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.unidade,
    required this.ibge,
    this.gia,
    this.ddd,
    this.siaf,
  });

  Cep.fromJson(Map<String, dynamic> json)
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

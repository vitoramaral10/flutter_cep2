import 'package:meta/meta.dart';

/// Represents Brazilian ZIP code (CEP) information.
///
/// This class contains all the address information returned by the ViaCEP API.
@immutable
class Cep {
  /// The ZIP code (CEP) in format XXXXX-XXX.
  final String cep;

  /// The street name (logradouro).
  final String logradouro;

  /// Additional address information (complemento).
  final String? complemento;

  /// The neighborhood (bairro).
  final String bairro;

  /// The city name (localidade).
  final String localidade;

  /// The state abbreviation (UF).
  final String uf;

  /// The state name (estado), e.g. "São Paulo".
  final String? estado;

  /// The region (regiao), e.g. "Sudeste".
  final String? regiao;

  /// The postal unit (unidade).
  final String? unidade;

  /// The IBGE city code.
  final String ibge;

  /// The GIA code (São Paulo only).
  final String? gia;

  /// The area code (DDD).
  final String? ddd;

  /// The SIAFI city code (sent by ViaCEP as `siafi`).
  final String? siaf;

  /// Creates a new [Cep] instance.
  const Cep({
    required this.cep,
    required this.logradouro,
    this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.estado,
    this.regiao,
    this.unidade,
    required this.ibge,
    this.gia,
    this.ddd,
    this.siaf,
  });

  /// Creates a [Cep] instance from a JSON map.
  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      estado: json['estado'] as String?,
      regiao: json['regiao'] as String?,
      unidade: json['unidade'] as String?,
      ibge: json['ibge'] as String? ?? '',
      gia: json['gia'] as String?,
      ddd: json['ddd'] as String?,
      siaf: (json['siafi'] ?? json['siaf']) as String?,
    );
  }

  /// Converts this [Cep] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'estado': estado,
        'regiao': regiao,
        'unidade': unidade,
        'ibge': ibge,
        'gia': gia,
        'ddd': ddd,
        'siaf': siaf,
      };

  @override
  String toString() {
    return 'Cep(cep: $cep, logradouro: $logradouro, bairro: $bairro, '
        'localidade: $localidade, uf: $uf)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cep &&
        other.cep == cep &&
        other.logradouro == logradouro &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.localidade == localidade &&
        other.uf == uf &&
        other.estado == estado &&
        other.regiao == regiao &&
        other.unidade == unidade &&
        other.ibge == ibge &&
        other.gia == gia &&
        other.ddd == ddd &&
        other.siaf == siaf;
  }

  @override
  int get hashCode {
    return Object.hash(
      cep,
      logradouro,
      complemento,
      bairro,
      localidade,
      uf,
      estado,
      regiao,
      unidade,
      ibge,
      gia,
      ddd,
      siaf,
    );
  }
}

/// Deprecated alias of [Cep].
@Deprecated('Use Cep instead')
// ignore: camel_case_types
typedef CEP = Cep;

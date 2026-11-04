final _nonDigits = RegExp(r'[^0-9]');

/// The digits of [cep], or null when there are not exactly 8 of them.
String? cepDigits(String cep) {
  final digits = cep.replaceAll(_nonDigits, '');
  return digits.length == 8 ? digits : null;
}

/// Whether [cep] has exactly 8 digits once punctuation is removed, as in
/// `01310-100`, `01310100` or `01.310-100`.
///
/// This only checks the format, without any request: a valid CEP may still
/// not exist.
bool isValidCep(String cep) => cepDigits(cep) != null;

/// Formats [cep] as `XXXXX-XXX`, or returns null when it is not valid (see
/// [isValidCep]).
///
/// ```dart
/// formatCep('01310100'); // '01310-100'
/// ```
String? formatCep(String cep) {
  final digits = cepDigits(cep);
  return digits == null
      ? null
      : '${digits.substring(0, 5)}-${digits.substring(5)}';
}

/// The state and region a CEP belongs to, by the Correios number ranges,
/// without any request.
///
/// Returns null when [cep] is not valid or falls outside every range. A few
/// CEPs (some large-volume receivers) do not follow the ranges, so use
/// `FlutterCep2.search` when the answer must be exact.
///
/// ```dart
/// cepState('01310-100'); // (uf: 'SP', estado: 'São Paulo', regiao: 'Sudeste')
/// ```
({String uf, String estado, String regiao})? cepState(String cep) {
  final digits = cepDigits(cep);
  if (digits == null) return null;
  final prefix = int.parse(digits.substring(0, 5));
  for (final (first, last, uf) in _ranges) {
    if (prefix >= first && prefix <= last) {
      final (estado, regiao) = _states[uf]!;
      return (uf: uf, estado: estado, regiao: regiao);
    }
  }
  return null;
}

/// Correios ranges by the first five digits, inclusive.
const _ranges = [
  (1000, 19999, 'SP'),
  (20000, 28999, 'RJ'),
  (29000, 29999, 'ES'),
  (30000, 39999, 'MG'),
  (40000, 48999, 'BA'),
  (49000, 49999, 'SE'),
  (50000, 56999, 'PE'),
  (57000, 57999, 'AL'),
  (58000, 58999, 'PB'),
  (59000, 59999, 'RN'),
  (60000, 63999, 'CE'),
  (64000, 64999, 'PI'),
  (65000, 65999, 'MA'),
  (66000, 68899, 'PA'),
  (68900, 68999, 'AP'),
  (69000, 69299, 'AM'),
  (69300, 69399, 'RR'),
  (69400, 69899, 'AM'),
  (69900, 69999, 'AC'),
  (70000, 72799, 'DF'),
  (72800, 72999, 'GO'),
  (73000, 73699, 'DF'),
  (73700, 76799, 'GO'),
  (76800, 76999, 'RO'),
  (77000, 77999, 'TO'),
  (78000, 78899, 'MT'),
  (79000, 79999, 'MS'),
  (80000, 87999, 'PR'),
  (88000, 89999, 'SC'),
  (90000, 99999, 'RS'),
];

const _states = {
  'AC': ('Acre', 'Norte'),
  'AL': ('Alagoas', 'Nordeste'),
  'AM': ('Amazonas', 'Norte'),
  'AP': ('Amapá', 'Norte'),
  'BA': ('Bahia', 'Nordeste'),
  'CE': ('Ceará', 'Nordeste'),
  'DF': ('Distrito Federal', 'Centro-Oeste'),
  'ES': ('Espírito Santo', 'Sudeste'),
  'GO': ('Goiás', 'Centro-Oeste'),
  'MA': ('Maranhão', 'Nordeste'),
  'MG': ('Minas Gerais', 'Sudeste'),
  'MS': ('Mato Grosso do Sul', 'Centro-Oeste'),
  'MT': ('Mato Grosso', 'Centro-Oeste'),
  'PA': ('Pará', 'Norte'),
  'PB': ('Paraíba', 'Nordeste'),
  'PE': ('Pernambuco', 'Nordeste'),
  'PI': ('Piauí', 'Nordeste'),
  'PR': ('Paraná', 'Sul'),
  'RJ': ('Rio de Janeiro', 'Sudeste'),
  'RN': ('Rio Grande do Norte', 'Nordeste'),
  'RO': ('Rondônia', 'Norte'),
  'RR': ('Roraima', 'Norte'),
  'RS': ('Rio Grande do Sul', 'Sul'),
  'SC': ('Santa Catarina', 'Sul'),
  'SE': ('Sergipe', 'Nordeste'),
  'SP': ('São Paulo', 'Sudeste'),
  'TO': ('Tocantins', 'Norte'),
};

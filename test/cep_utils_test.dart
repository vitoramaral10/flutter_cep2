import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:test/test.dart';

void main() {
  group('isValidCep', () {
    test('accepts 8 digits with any punctuation', () {
      for (final cep in [
        '01310100',
        '01310-100',
        '01.310-100',
        ' 01310 100 '
      ]) {
        expect(isValidCep(cep), isTrue, reason: cep);
      }
    });

    test('rejects other lengths', () {
      for (final cep in ['', '0131010', '013101000', 'abcdefgh']) {
        expect(isValidCep(cep), isFalse, reason: cep);
      }
    });

    test('rejects numbers outside every state range', () {
      for (final cep in ['00000-000', '00999-999', '78900-000', '78999-999']) {
        expect(isValidCep(cep), isFalse, reason: cep);
      }
      for (final cep in ['01000-000', '78899-999', '79000-000', '99999-999']) {
        expect(isValidCep(cep), isTrue, reason: cep);
      }
    });
  });

  group('formatCep', () {
    test('formats as XXXXX-XXX', () {
      expect(formatCep('01310100'), '01310-100');
      expect(formatCep('01.310-100'), '01310-100');
    });

    test('is null for an invalid CEP', () {
      expect(formatCep('123'), isNull);
      expect(formatCep('00000000'), isNull);
    });
  });

  group('cepState', () {
    test('finds the state and region', () {
      expect(
        cepState('01310-100'),
        (uf: 'SP', estado: 'São Paulo', regiao: 'Sudeste'),
      );
    });

    test('follows the split ranges', () {
      // Each pair: the CEP and the UF it must map to.
      const cases = {
        '00999999': null, // below the first range
        '01000000': 'SP',
        '19999999': 'SP',
        '68899999': 'PA',
        '68900000': 'AP',
        '69299999': 'AM',
        '69300000': 'RR',
        '69400000': 'AM',
        '69900000': 'AC',
        '72799999': 'DF',
        '72800000': 'GO',
        '73000000': 'DF',
        '73700000': 'GO',
        '76800000': 'RO',
        '77000000': 'TO',
        '78899999': 'MT',
        '78900000': null, // gap between MT and MS
        '79000000': 'MS',
        '99999999': 'RS',
      };
      cases.forEach((cep, uf) {
        expect(cepState(cep)?.uf, uf, reason: cep);
      });
    });

    test('covers every state', () {
      final ufs = {
        for (var prefix = 0; prefix < 100000; prefix += 100)
          cepState('${prefix.toString().padLeft(5, '0')}000')?.uf,
      }..remove(null);
      expect(ufs, hasLength(27));
    });

    test('is null for an invalid CEP', () {
      expect(cepState('123'), isNull);
    });
  });
}

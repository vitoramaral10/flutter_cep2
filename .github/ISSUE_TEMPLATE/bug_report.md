---
name: 🐛 Bug Report
about: Reporte um bug encontrado na biblioteca
title: "[BUG] "
labels: bug
assignees: ''
---

## 📝 Descrição do Bug

<!-- Descreva claramente qual é o bug -->

## 🔍 Como Reproduzir

Steps para reproduzir o comportamento:

1. ...
2. ...
3. ...

## 📺 Comportamento Esperado

<!-- Descreva o que você esperava que acontecesse -->

## 📺 Comportamento Atual

<!-- Descreva o que realmente acontece -->

## 💻 Código Mínimo para Reproduzir

```dart
// Adicione um exemplo mínimo que reproduz o bug
final cepService = FlutterCep2();

try {
  final result = await cepService.search('01310-100');
} catch (e) {
  print('Error: $e');
}
```

## 🖥️ Ambiente

- **Flutter version**: <!-- Resultado de `flutter --version` -->
- **Dart version**: <!-- Resultado de `dart --version` -->
- **flutter_cep2 version**: <!-- Ex: 1.0.2 -->
- **OS**: <!-- Windows, macOS, Linux, iOS, Android, Web -->
- **Device**: <!-- Ex: Samsung Galaxy S21, iPhone 13, etc -->

## 📎 Logs

<!-- Adicione logs relevantes aqui. Use ```console ``` para formatar -->

```console
[Cole os logs aqui]
```

## 📌 Checklist

- [ ] Verifiquei se este bug já foi reportado
- [ ] Estou usando a versão mais recente da biblioteca
- [ ] Este é um bug reproduzível
- [ ] Incluí um código mínimo que reproduz o bug

## 📝 Informação Adicional

<!-- Adicione qualquer informação adicional que possa ser útil -->

---
name: 🐛 Bug Report
about: Reporte um bug encontrado na biblioteca
title: "[BUG] "
labels: bug
assignees: ''
---

## 📝 Descrição do Bug

<!-- Descreva claramente e concisamente qual é o bug. Uma ou duas frases são suficientes. -->

## 🔍 Como Reproduzir

Steps para reproduzir o comportamento:

1. ...
2. ...
3. ...

## 📺 Comportamento Esperado

<!-- Descreva o que você esperava que acontecesse -->

## 📺 Comportamento Atual

<!-- Descreva o que realmente acontece. Seja específico! -->

## 💻 Código Mínimo para Reproduzir

<!-- OBRIGATÓRIO: Sem este código, a issue não pode ser investigada -->

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

## 📎 Stack Trace / Logs

<!-- Adicione o stack trace completo ou logs relevantes. Use ```console ``` para formatar -->

```console
[Cole o stack trace ou logs aqui]
```

## 📸 Screenshots

<!-- Se aplicável, adicione screenshots do erro -->

## 📌 Checklist

- [ ] Verifiquei se este bug já foi reportado procurando nas issues
- [ ] Estou usando a versão mais recente da biblioteca
- [ ] Este é um bug consistentemente reproduzível
- [ ] Incluí um código mínimo que reproduz o bug (OBRIGATÓRIO)
- [ ] Incluí informações completas do meu ambiente

## 📝 Contexto Adicional

<!-- Adicione qualquer outra informação que possa ser útil, como:
- Quando começou o problema (ex: após atualizar para versão X)
- Se o bug afeta apenas certos cenários
- Possível causa raiz (se souber)
-->

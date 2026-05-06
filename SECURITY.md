# 🔒 Política de Segurança

## Reportando uma Vulnerabilidade

Se você descobrir uma vulnerabilidade de segurança, **não abra uma issue pública**. Em vez disso, siga estas instruções:

### 📧 Como Reportar

**Email:** [vitor.amaral10@gmail.com](mailto:vitor.amaral10@gmail.com)

**Assunto:** `[SECURITY] Breve descrição da vulnerabilidade`

**Inclua:**
- Descrição clara e detalhada da vulnerabilidade
- Passos para reproduzir (com código exemplo se possível)
- Versões afetadas do flutter_cep2
- Versões do Dart/Flutter usadas
- Impacto potencial e severidade
- Sugestão de correção (se tiver)
- Seu nome/contato (opcional)

### ⏱️ Processo de Divulgação Responsável

1. **Você relata** a vulnerabilidade por email
2. **Confirmamos recebimento** em até 48 horas
3. **Avaliamos** o impacto e severidade
4. **Investigamos** e desenvolvemos uma correção
5. **Testamos** a correção e criamos testes
6. **Preparamos** um release com a correção
7. **Coordenamos divulgação** antes de qualquer publicação
8. **Agradecemos** o reporte responsável

**Timeline esperada:** 30-90 dias (depende da complexidade)

### 🔐 Confidencialidade

- Sua identidade será mantida confidencial (se desejar)
- Você será creditado na correção se permitir
- As informações da vulnerabilidade não serão divulgadas antes de uma correção ser lançada
- Não usaremos as informações para outros fins

## Versões Suportadas

| Versão | Status | Suporte de Segurança |
|--------|--------|----------------------|
| 1.x | Atual | ✅ Recebe atualizações |
| 0.x | Descontinuada | ⚠️ Sem suporte |

## 🛡️ Boas Práticas de Segurança

### Para Desenvolvedores da Biblioteca

#### Dependências
- Mantemos dependências atualizadas via Dependabot
- Monitoramos avisos de segurança do Dart Hub
- Executamos `dart pub outdated` regularmente
- Revisamos changelogs de dependências

#### Validação de Entrada
- Todos os inputs são validados antes de uso
- CEPs inválidos são rejeitados com exceções apropriadas
- Erros são tratados sem expor informações sensíveis
- Implementamos rate limiting em requisições

#### HTTP/HTTPS
- Usamos a biblioteca `http` oficial do Dart
- Certificados SSL/TLS são validados automaticamente
- Nenhum dado sensível é logado
- Requisições usam HTTPS exclusivamente

#### Testes de Segurança
```bash
# Análise estática
dart analyze --fatal-infos

# Verificar dependências vulneráveis
dart pub deps

# Rodar testes
dart test
```

### Para Usuários da Biblioteca

#### Validar Entrada
```dart
// ✅ Bom
if (cep != null && cep.isNotEmpty) {
  final result = await cepService.search(cep.trim());
}

// ❌ Ruim - sem validação
final result = await cepService.search(userInput);
```

#### Tratar Erros Apropriadamente
```dart
try {
  final result = await cepService.search(cep);
} on CepException catch (e) {
  // Handle erro específico
  logger.warning('CEP não encontrado: $e');
} catch (e) {
  // Handle erro genérico sem expor detalhes
  logger.error('Erro ao buscar CEP');
}
```

#### Nunca Logar Dados Sensíveis
```dart
// ❌ Ruim - expõe dados
print('CEP: $cep, Resultado: $result');

// ✅ Bom - sem dados sensíveis
logger.info('Busca de CEP completada');
```

#### Manter Dependências Atualizadas
```bash
# Verificar atualizações
dart pub outdated

# Atualizar dependências
dart pub upgrade
```

## 🔍 Verificação de Segurança Contínua

O projeto passa por:

- ✅ **Análise estática** com `dart analyze`
- ✅ **Linting** com regras estritas (dart_code_metrics)
- ✅ **Testes automatizados** em cada commit
- ✅ **Code review** obrigatório em todas as PRs
- ✅ **SonarCloud** para detecção de hotspots
- ✅ **Dependabot** para monitoramento de vulnerabilidades
- ✅ **Coverage** mínimo de 80% em código novo

## 🚨 Hotspots de Segurança Conhecidos

Nenhum no momento. Se encontrar, reporte via email como descrito acima.

## 📋 Histórico de Vulnerabilidades

Nenhuma vulnerabilidade reportada até agora.

## ⚠️ O Que flutter_cep2 NÃO Garante

- ❌ Não faz cache de resultados (cada busca é nova)
- ❌ Não usa criptografia ponta-a-ponta
- ❌ Não autentica ao serviço de CEP
- ❌ Não oferece proteção contra throttling/rate limiting
- ❌ Não substitui validações no seu backend

## 🔗 Recursos Relacionados

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)
- [Dart Security Best Practices](https://dart.dev/security)
- [Flutter Security](https://flutter.dev/docs/testing/security-testing)
- [Pub.dev Security Standards](https://pub.dev/help)

## 📞 Contato

**Para relatar vulnerabilidades:**
- Email: [vitor.amaral10@gmail.com](mailto:vitor.amaral10@gmail.com)

**Para outras questões de segurança:**
1. Consulte [README.md](README.md)
2. Abra uma [discussão](https://github.com/vitoramaral10/flutter_cep2/discussions)
3. Procure [issues existentes](https://github.com/vitoramaral10/flutter_cep2/issues)

---

**Obrigado por ajudar a manter flutter_cep2 seguro! 🙏**

Última atualização: 2026-05-06

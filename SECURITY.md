# 🔒 Política de Segurança

## Reportando uma Vulnerabilidade

Se você descobrir uma vulnerabilidade de segurança, **não abra uma issue pública**. Em vez disso, siga estas instruções:

### 📧 Como Reportar

1. **Envie um email** para: [vitor.amaral10@gmail.com](mailto:vitor.amaral10@gmail.com)
2. **Inclua:**
   - Descrição clara da vulnerabilidade
   - Passos para reproduzir
   - Impacto potencial
   - Versões afetadas
   - Sugestão de correção (se tiver)

### ⏱️ Processo de Divulgação Responsável

1. Você relata a vulnerabilidade
2. Confirmamos recebimento em até 48 horas
3. Investigamos e desenvolvemos uma correção
4. Preparamos um release com a correção
5. Divulgamos a vulnerabilidade e agradecemos o reporte

**Timeline esperada:** 30-90 dias

### 🔐 Confidencialidade

- Sua identidade será mantida confidencial
- Você será creditado na correção se desejar
- As informações da vulnerabilidade não serão divulgadas antes de uma correção ser lançada

## 🛡️ Boas Práticas de Segurança

### Dependências

- Mantemos dependências atualizadas
- Monitorizamos avisos de segurança do Dart
- Usamos `dart pub outdated` regularmente

### Validação de Entrada

- Todos os inputs são validados
- Erros são tratados adequadamente
- Mensagens de erro não expõem informações sensíveis

### HTTP Requests

- Usamos a biblioteca `http` oficial do Dart
- Certificados SSL/TLS são validados
- Sem logs de dados sensíveis

## 🔍 Verificação de Segurança

O projeto passa por:

- ✅ Análise estática com `dart analyze`
- ✅ Linting com regras estritas
- ✅ Testes automatizados
- ✅ Code review em todas as PRs

## 📋 Histórico de Vulnerabilidades

Nenhuma vulnerabilidade reportada até agora.

## 🔗 Recursos

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)
- [Dart Security](https://dart.dev/security)

---

**Obrigado por ajudar a manter flutter_cep2 seguro! 🙏**

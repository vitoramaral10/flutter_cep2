# 👥 Maintainers - flutter_cep2

Este documento define os papéis, responsabilidades e processos de governança do projeto flutter_cep2.

**Última atualização:** 2026-05-06

---

## 🏛️ Estrutura de Governança

```
Project Owner
    └─ Lead Maintainer
         ├─ Core Maintainers
         ├─ Contributors
         └─ Community
```

---

## 👤 Mantenedores Atuais

### Project Owner & Lead Maintainer
- **Nome:** Vitor Melo
- **Email:** vitor.amaral10@gmail.com
- **GitHub:** [@vitoramaral10](https://github.com/vitoramaral10)
- **Responsabilidade:** Visão estratégica, releases, decisões arquiteturais

---

## 📋 Papéis e Responsabilidades

### 1. Project Owner

**Quem:** Vitor Melo

**Responsabilidades:**
- 🎯 Definir visão e direção estratégica do projeto
- 📅 Planejar releases e milestones
- 🔐 Manter segurança e confiabilidade
- 👥 Gerenciar mantenedores e contribuidores
- 🐛 Decisão final em conflitos técnicos
- 📢 Comunicar direção do projeto
- 🔑 Gerenciar secrets (tokens, credentials)

**Tempo Esperado:** 5-10 horas/semana

---

### 2. Lead Maintainer

**Atualmente:** Vitor Melo

**Responsabilidades:**
- ✅ Code review em todas as PRs
- 📝 Manter documentação atualizada
- 🧪 Garantir qualidade de testes (80%+)
- 🔍 Verificar segurança (SonarCloud)
- 📊 Monitorar issues e PRs
- 🚀 Coordenar releases
- 💬 Responder issues e discussões
- 📚 Manter CHANGELOG e documentação

**SLA (Service Level Agreement):**
- Issues: Responder em < 48 horas
- PRs de bugs críticos: Review em < 24 horas
- PRs regulares: Review em < 72 horas
- Features: Discussão antes de implementar

**Tempo Esperado:** 10-15 horas/semana

---

### 3. Core Maintainers

**Critérios para ser Core Maintainer:**
- ✅ 10+ PRs merged
- ✅ 6+ meses de contribuições ativas
- ✅ Demonstrar conhecimento do codebase
- ✅ Comportamento profissional e construtivo
- ✅ Nomear por Lead Maintainer + comunidade

**Responsabilidades:**
- ✅ Code review em PRs
- 🔍 Teste de funcionalidades
- 📝 Atualizar documentação
- 💬 Ajudar contribuidores
- 🐛 Investigar e categorizar issues
- 🚀 Participar do planejamento

**SLA:**
- PRs: Review em < 3 dias
- Issues: Triagem em < 48 horas

**Tempo Esperado:** 5-10 horas/semana

**Privilégios:**
- Merge PRs (com consentimento de outro core maintainer)
- Criar e editar labels em issues
- Fechar issues com justificativa
- Atribuir milestones

---

### 4. Contributors

**Quem:** Comunidade aberta

**Como contribuir:**
1. Fork o repositório
2. Crie uma branch: `feat/sua-feature` ou `fix/seu-bug`
3. Siga [CONTRIBUTING.md](CONTRIBUTING.md)
4. Abra um PR com descrição clara
5. Participe do code review
6. Merge após aprovação

**Responsabilidades:**
- 📝 Seguir Conventional Commits
- 🧪 Adicionar testes para mudanças
- 📚 Atualizar documentação
- 🔄 Responder feedback do code review
- 💬 Comportamento respeitoso

**Tempo Esperado:** Flexível (por PR)

---

## 🎯 Processo de Promoção

### Contributor → Core Maintainer

**Passos:**
1. **Demonstre Expertise** (6+ meses)
   - 10+ PRs bem-sucedidas
   - Código de alta qualidade
   - Testes abrangentes
   - Documentação clara

2. **Engajamento Comunitário**
   - Ajude em issues/discussions
   - Faça code review construtivo
   - Organize seu tempo para manter

3. **Nomeação** (por Lead Maintainer)
   - Discussão com comunidade
   - Aceitação formal
   - Adição ao MAINTAINERS.md

4. **Onboarding**
   - Acesso a deploy keys
   - Explicação de processos
   - Acesso a secretos (após verificação)

**Tempo de Vesting:** 6 meses (se não mais ativo, perde permissões)

---

### Core Maintainer → Lead Maintainer

**Critérios:**
- ✅ 2+ anos ativo no projeto
- ✅ 50+ PRs merged
- ✅ Conhecimento profundo da arquitetura
- ✅ Demonstrado senso de responsabilidade
- ✅ Consenso da comunidade

**Processo:**
1. Discussão privada com Project Owner
2. Verificação de capacidade e disponibilidade
3. Formalização (update MAINTAINERS.md)
4. Onboarding em processos de release

---

## 📊 Responsabilidades por Tipo de Issue

### Bugs Críticos (Security, Data Loss)
- **Lead Maintainer:** Review em < 24h
- **SLA:** Fix em < 7 dias
- **Release:** Patch imediato (semana seguinte)

### Bugs Regulares
- **Core Maintainer:** Review em < 72h
- **SLA:** Fix em < 30 dias
- **Release:** Próximo patch/minor

### Features
- **Discussão:** Antes de começar coding
- **Review:** < 3 dias
- **Merge:** Após aprovação de 2+ core maintainers

### Documentation
- **Review:** < 48h
- **Merge:** Rápido (baixo risco)

### Chores/CI
- **Review:** < 48h
- **Merge:** Automático após CI passar

---

## 🔄 Processos de Manutenção

### Daily
- 📧 Monitorar notificações do GitHub
- 💬 Responder comentários em PRs/issues
- 🔍 Revisar PRs abertas

### Weekly
- 📊 Revisar métricas (coverage, performance)
- 🐛 Triagem de issues novas
- 🔐 Verificar alertas de segurança (Dependabot)

### Monthly
- 📈 Análise de metrics (downloads, stars)
- 📅 Planejamento de próximo sprint
- 🔍 Revisão de segurança (SonarCloud)
- 📢 Comunicação com comunidade

### Quarterly
- 🎯 Revisão de roadmap
- 📊 Planejar próxima versão
- 🤝 Avaliação de novos mantenedores
- 📝 Atualizar documentação

### Yearly
- 🏆 Retrospectiva do projeto
- 🎯 Definir objetivos para próximo ano
- 👥 Revisão de mantenedores
- 📈 Planejar grandes mudanças

---

## 🚀 Processo de Release

### Pre-Release (1 semana antes)
1. Congelar código (freeze branch)
2. Revisar CHANGELOG
3. Atualizar versão em pubspec.yaml
4. Criar release branch
5. Teste final

### Release Day
1. Merge release branch
2. Create git tag
3. Build e upload para Pub.dev
4. Publicar release notes
5. Comunicar em discussions

### Post-Release (24h depois)
1. Monitorar issues de regressão
2. Responder feedback
3. Documentar lições aprendidas

---

## 📝 Comunicação

### Canais Oficiais
- 💬 **GitHub Issues:** Bugs e features
- 💬 **GitHub Discussions:** Dúvidas e ideias
- 📧 **Email:** vitor.amaral10@gmail.com (segurança)

### Expectativas de Resposta
- **Issues:** < 48 horas
- **Discussions:** < 72 horas
- **Email:** < 24 horas (segurança)
- **PRs:** < 72 horas

### Escalation
1. Sem resposta em 48h → Ping em issue
2. Sem resposta em 1 semana → Email para Lead Maintainer
3. Sem resposta em 2 semanas → Abertura de meta-issue

---

## 🔒 Acesso e Segurança

### Acesso por Nível

| Acesso | Contributor | Core Maintainer | Lead Maintainer |
|--------|-------------|-----------------|-----------------|
| Ler issues | ✅ | ✅ | ✅ |
| Comentar | ✅ | ✅ | ✅ |
| Criar PR | ✅ | ✅ | ✅ |
| Merge PR | ❌ | ✅ | ✅ |
| Criar release | ❌ | ❌ | ✅ |
| Manage secrets | ❌ | ❌ | ✅ |
| Add members | ❌ | ❌ | ✅ |
| Pub.dev publish | ❌ | ❌ | ✅ |

### Security Keys
- **Pub.dev API Token:** Lead Maintainer only
- **GitHub PAT:** Lead Maintainer only
- **SonarCloud Token:** Lead Maintainer + Core Maintainers (read-only)
- **All secrets in:** GitHub Secrets (not in code)

### Two-Factor Authentication (2FA)
- **Required for:** Lead Maintainer
- **Recommended for:** Core Maintainers
- **Good practice for:** All contributors

---

## 📜 Código de Conduta

Todos os mantenedores concordam com:
- 🤝 [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md)
- 📋 [Contributing Guidelines](CONTRIBUTING.md)
- 🛡️ [Security Policy](SECURITY.md)

**Esperamos:**
- ✅ Comportamento respeitoso e profissional
- ✅ Feedback construtivo e empático
- ✅ Inclusão e diversidade
- ✅ Transparência em decisões
- ✅ Confidencialidade de dados sensíveis

**Violações podem resultar em:**
- ⚠️ Aviso
- 🚫 Suspensão de comentários
- 🔚 Remoção como mantenedor

---

## 🤝 Como Se Envolver

### Se você quer contribuir:
1. Leia [CONTRIBUTING.md](CONTRIBUTING.md)
2. Escolha uma issue com `good-first-issue` label
3. Comente "Gostaria de ajudar"
4. Faça um fork e crie uma PR

### Se você quer ser Core Maintainer:
1. Faça 10+ PRs de qualidade
2. Engaje em discussions
3. Ajude reviewando código de outros
4. Espere 6+ meses e demonstre commitment
5. Será considerado para promoção

### Se você quer reportar bug/vulnerability:
- 🐛 Bug comum: Abra uma issue
- 🔒 Vulnerability: Email para vitor.amaral10@gmail.com

---

## 📚 Recursos para Mantenedores

### Guidelines
- [Contributing Guide](CONTRIBUTING.md)
- [Conventional Commits](COMMIT_GUIDELINES.md)
- [Security Policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

### Checklists
- [Release Checklist](#processo-de-release)
- [Code Review Checklist](#responsabilidades-por-tipo-de-issue)

### Tools
- **Local testing:** `dart test --coverage`
- **Code quality:** `dart analyze --fatal-infos`
- **Formatting:** `dart format .`
- **Metrics:** `dart_code_metrics:metrics analyze lib`

---

## 🎯 Métricas de Sucesso para Mantenedores

Acompanhamos:
- ⏱️ Tempo médio de resposta em issues
- 📊 Taxa de merge de PRs
- 🐛 Issues resolvidas por mês
- 📈 Cobertura de testes
- ⭐ Satisfação da comunidade

---

## 📞 Contato

- 📧 **Email:** vitor.amaral10@gmail.com
- 💬 **Discussions:** https://github.com/vitoramaral10/flutter_cep2/discussions
- 🐛 **Issues:** https://github.com/vitoramaral10/flutter_cep2/issues

---

**Última atualização:** 2026-05-06  
**Próxima revisão:** 2026-08-06

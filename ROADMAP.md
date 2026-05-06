# 🗺️ Roadmap - flutter_cep2

Este documento descreve a visão e direção futura do projeto flutter_cep2. É um guia vivo que pode ser atualizado conforme as prioridades evoluem.

**Última atualização:** 2026-05-06

---

## 📍 Visão Geral

flutter_cep2 é uma biblioteca Dart/Flutter para buscar informações de endereços através de CEP (Código de Endereçamento Postal) brasileiros. Nossa visão é:

> **Fornecer a forma mais simples, confiável e bem documentada de buscar endereços por CEP em aplicações Dart e Flutter.**

### Objetivos Principais
- 🎯 **Simplicidade**: API intuitiva e fácil de usar
- 🎯 **Confiabilidade**: Cobertura de testes > 90%, zero vulnerabilidades conhecidas
- 🎯 **Documentação**: Exemplos claros, guias passo-a-passo, tutorial completo
- 🎯 **Performance**: Requisições rápidas, cache opcional, sem dependências pesadas
- 🎯 **Comunidade**: Contribuições bem-vidas, processo de contribuição claro

---

## 🚀 Roadmap por Versão

### v1.0 ✅ (Já Lançado - Atual)

**Status:** Estável

#### Features Implementadas
- ✅ Busca de CEP com múltiplos providers
- ✅ Tratamento robusto de erros
- ✅ Testes automatizados (80%+ coverage)
- ✅ Documentação completa
- ✅ GitHub Actions CI/CD
- ✅ SonarCloud quality gates
- ✅ Dependabot security scanning

#### Qualidade & Infra
- ✅ Code review automático em PRs
- ✅ Coverage checks (80% minimum)
- ✅ Security policy e guidelines
- ✅ Issue e PR templates
- ✅ Git hooks para Conventional Commits

---

### v1.1 🎯 (Próximo - Planejado para Q2 2026)

**Foco:** Melhorias de Performance e Usabilidade

#### Features Planejadas

1. **Cache Local** (Prioridade Alta)
   - Armazenar resultados em memória (curto prazo)
   - Opção de persistência em disk (usando SharedPreferences)
   - Configuração de TTL do cache
   - Exemplos de uso com cache
   ```dart
   final cep = FlutterCep2(enableCache: true, cacheTtl: Duration(hours: 24));
   ```

2. **Retry Logic Melhorada** (Prioridade Alta)
   - Retry automático com backoff exponencial
   - Configuração de tentativas máximas
   - Estratégias de retry customizáveis
   ```dart
   final cep = FlutterCep2(
     maxRetries: 3,
     retryDelay: Duration(milliseconds: 500),
   );
   ```

3. **Timeout Configurável** (Prioridade Média)
   - Timeout por requisição
   - Timeout global customizável
   - Melhor mensagens de erro para timeouts

4. **Logging Estruturado** (Prioridade Média)
   - Suporte a loggers customizados
   - Níveis de log (debug, info, warning, error)
   - Logging sem dados sensíveis

#### Não-Goals para v1.1
- ❌ Geolocalização (fora do escopo)
- ❌ Busca por endereço incompleto (complexo demais)
- ❌ Integração com Google Maps (dependência pesada)

---

### v1.2 🔮 (Futuro - Planejado para Q3 2026)

**Foco:** Validação e Formatação Avançada

#### Features Planejadas

1. **Formatadores de CEP** (Prioridade Alta)
   - Formatar CEP: `01310100` → `01310-100`
   - Remover formatação: `01310-100` → `01310100`
   - Validação de CEP com regex/algoritmo
   ```dart
   final formatter = CepFormatter();
   formatter.format('01310100'); // '01310-100'
   formatter.validate('01310100'); // true
   ```

2. **Validação Avançada** (Prioridade Alta)
   - Verificar se CEP existe antes de fazer request
   - Cache de CEPs válidos/inválidos
   - Sugestões para CEPs digitados errado (fuzzy matching)

3. **Múltiplos Providers** (Prioridade Média)
   - Suporte a providers adicionais (ViaCEP, BrasilAPI, etc)
   - Fallback automático entre providers
   - Interface para custom providers
   ```dart
   final cep = FlutterCep2(
     providers: [ViaCepProvider(), BrasilApiProvider()],
     fallbackEnabled: true,
   );
   ```

4. **Internacionalização** (Prioridade Baixa)
   - Mensagens de erro em múltiplos idiomas
   - Documentação em EN/PT/ES

---

### v2.0 🎊 (Longo Prazo - 2027+)

**Foco:** Reescrita com novos recursos e melhorias arquiteturais

#### Possíveis Features

1. **Busca Reversa** (Endereço → CEP)
   - Buscar CEPs por endereço/cidade/bairro
   - Múltiplos resultados com ranking

2. **Geolocalização Integrada**
   - Buscar endereço a partir de coordenadas
   - Verificar se coordenadas estão dentro de um CEP

3. **Modo Offline**
   - Database local de CEPs
   - Sincronização periódica
   - Busca sem internet

4. **API Platform Independent**
   - Suporte a Web, Mobile, Desktop, CLI
   - Mesma API em todas as plataformas

5. **Observabilidade**
   - Métricas de requisições
   - Analytics de CEPs mais buscados
   - Dashboard de performance

6. **Arquitetura Melhorada**
   - Separação de responsabilidades
   - Plugin system para providers
   - DI (Dependency Injection) pattern

---

## 📊 Timeline Aproximada

```
2026-Q2  ├─ v1.1 Cache, Retry, Timeout
         │
2026-Q3  ├─ v1.2 Formatação, Validação, Multi-provider
         │
2026-Q4  ├─ v1.3 Refinamentos e community feedback
         │
2027-Q1  ├─ v2.0 (Planejamento)
         │
2027+    └─ Evoluções baseadas em feedback
```

---

## 🏗️ Qualidade & Infra (Contínuo)

Essas iniciativas são **contínuas** e não vinculadas a versões específicas:

### CI/CD
- ✅ GitHub Actions para test/build/publish
- ✅ Automatização de versioning semântico
- ✅ Deploy automático ao Pub.dev
- 🔄 Dashboard de status dos workflows
- 🔄 Notificações de build failure

### Code Quality
- ✅ SonarCloud com quality gates
- ✅ Coverage 80%+ obrigatório
- ✅ Análise estática com dart_code_metrics
- 🔄 Benchmark de performance
- 🔄 Análise de segurança mensal

### Documentation
- ✅ README com exemplos
- ✅ CONTRIBUTING.md com guia
- 🔄 Tutorial interativo passo-a-passo
- 🔄 Vídeo tutorial no YouTube
- 🔄 Comparação com outras bibliotecas

### Community
- ✅ Discussões abertas no GitHub
- ✅ Issue e PR templates
- 🔄 Comunidade Discord/Slack
- 🔄 Contribuidor do mês
- 🔄 Changelog leído por maintainer

---

## 🤝 Como Contribuir com o Roadmap

### Propor Novas Features
1. Abra uma [Discussion](https://github.com/vitoramaral10/flutter_cep2/discussions)
2. Descreva o caso de uso e o problema
3. Sugira uma solução
4. Aguarde feedback da comunidade

### Implementar Features do Roadmap
1. Comente na issue/discussion se quer trabalhar
2. Siga o [CONTRIBUTING.md](CONTRIBUTING.md)
3. Abra PR quando tiver pronto
4. Participe do code review

### Reportar Bugs
1. Verifique se é um bug ou feature request
2. Abra uma issue com template apropriado
3. Inclua passos para reproduzir
4. Aguarde investigação

---

## 📈 Métricas de Sucesso

Acompanhamos esses indicadores:

| Métrica | Atual | Meta 2026 |
|---------|-------|-----------|
| Downloads no Pub.dev | ~100/mês | 500+/mês |
| GitHub Stars | ~10 | 50+ |
| Issues resolvidas | 85% | 95%+ |
| Test Coverage | 80%+ | 90%+ |
| Response time (issues) | <48h | <24h |
| Security vulnerabilities | 0 | 0 |

---

## 🔐 Princípios de Desenvolvimento

Ao trabalhar no roadmap, mantemos esses princípios:

1. **Simplicidade Primeiro** - Não adicione features se não simplificarem o uso
2. **Sem Breaking Changes** - Versionamento semântico rigoroso
3. **Testes Obrigatórios** - Toda feature tem testes
4. **Documentação Junto** - Feature + docs + exemplos
5. **Community First** - Ouça o feedback antes de decidir
6. **Segurança Sempre** - Security review em toda mudança

---

## 📞 Dúvidas sobre o Roadmap?

- 💬 [Abra uma Discussion](https://github.com/vitoramaral10/flutter_cep2/discussions)
- 📧 [Email](mailto:vitor.amaral10@gmail.com)
- 🐛 [Reporte um bug](https://github.com/vitoramaral10/flutter_cep2/issues)

---

**Última atualização:** 2026-05-06  
**Próxima revisão:** 2026-06-06

# GitHub Actions Setup Guide

Este documento descreve como configurar a publicação automática no pub.dev usando GitHub Actions com OIDC (OAuth).

## 🔐 Passo 1: Configurar OIDC no pub.dev

O pub.dev agora suporta OIDC (OpenID Connect), o que é mais seguro que usar access tokens estáticos.

### 1.1 Acessar Configurações no pub.dev

1. Acesse: https://pub.dev/user/account-settings
2. Faça login com sua conta do pub.dev
3. Na seção "Publishing Credentials", clique em "Manage"

### 1.2 Adicionar GitHub como Provider de Confiança

1. Clique em "Add OIDC Provider" ou similar
2. Selecione **GitHub** como provedor
3. Preencha:
   - **Repository Owner**: `vitoramaral10` (seu usuário GitHub)
   - **Repository Name**: `flutter_cep2`
   - **Workflow File Path**: `.github/workflows/publish.yml`
4. Salve as configurações

## 📋 Passo 2: Adicionar Labels nas PRs

Use estes labels nas PRs para controlar o versionamento automático:

| Label | Incremento | Exemplo |
|-------|-----------|---------|
| `breaking` | Major (1.0.0 → 2.0.0) | Mudanças incompatíveis com versões anteriores |
| `feature` | Minor (1.0.0 → 1.1.0) | Novas funcionalidades |
| `fix` | Patch (1.0.0 → 1.0.1) | Correções de bugs |
| `docs` | Patch (1.0.0 → 1.0.1) | Melhorias de documentação |

## 🔄 Como o Fluxo Funciona

### Fluxo Completo

```
1. Você cria uma PR com label (ex: "feature")
                    ↓
2. CI roda tests automaticamente (workflow: test.yml)
                    ↓
3. Você faz merge da PR na main
                    ↓
4. GitHub Actions detecta merge (workflow: release.yml)
                    ↓
5. Calcula nova versão (1.0.2 → 1.1.0)
                    ↓
6. Atualiza pubspec.yaml
                    ↓
7. Cria commit com novo version
                    ↓
8. Cria tag git (v1.1.0)
                    ↓
9. Cria GitHub Release
                    ↓
10. Publica automaticamente no pub.dev (workflow: publish.yml)
```

## 📦 Exemplo na Prática

### Cenário 1: Merge de Feature

```bash
# 1. Você faz merge de PR com label "feature"
# Versão atual no pubspec.yaml: 1.0.2

# 2. GitHub Actions executa automaticamente:
# - Detecta label "feature"
# - Calcula: 1.0.2 → 1.1.0 (incrementa minor)
# - Atualiza pubspec.yaml para 1.1.0
# - Cria commit automático
# - Cria tag v1.1.0
# - Publica no pub.dev automaticamente

# 3. Resultado: Seu pacote está disponível em pub.dev com versão 1.1.0
```

### Cenário 2: Merge de Correção (Fix)

```bash
# Versão atual: 1.1.0
# Label na PR: "fix"

# Resultado: v1.1.1 (incrementa patch)
```

### Cenário 3: Merge de Breaking Change

```bash
# Versão atual: 1.1.0
# Label na PR: "breaking"

# Resultado: v2.0.0 (incrementa major)
```

## 🔍 Monitorar Execução

Após fazer merge de uma PR:

1. Acesse: https://github.com/vitoramaral10/flutter_cep2/actions
2. Você verá 3 workflows executando:
   - ✅ **Tests**: Valida testes e formatação
   - ✅ **Create Release and Tag**: Cria versão e tag
   - ✅ **Publish to pub.dev**: Publica no pub.dev

## 🚨 Troubleshooting

### Problema: "OIDC provider not found"

**Solução**: Verifique se você configurou corretamente o OIDC no pub.dev:
- Repository Owner deve ser exato (maiúsculas/minúsculas)
- Repository Name deve ser exato
- Workflow file path deve ser `.github/workflows/publish.yml`

### Problema: PR não tem label

**Solução**: O workflow usa "patch" como padrão se nenhum label for encontrado.

### Problema: Versão não foi atualizada

**Solução**: Verifique se:
1. O workflow tem permissão para fazer push (check: `contents: write`)
2. A PR foi realmente merged (não apenas fechada)
3. A PR foi merged na branch `main`

## 📚 Referências

- [pub.dev OIDC Documentation](https://dart.dev/tools/pub/publishing)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org)

## ✅ Checklist de Configuração

- [ ] Configurei OIDC no pub.dev
- [ ] Adicionei GitHub como provider de confiança
- [ ] Testei fluxo com uma PR de test
- [ ] Verifiquei que a publicação funcionou em pub.dev
- [ ] Adicionei labels nas futuras PRs

---

**Dúvidas?** Abra uma issue em: https://github.com/vitoramaral10/flutter_cep2/issues

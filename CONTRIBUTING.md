# Contribuindo para o flutter_cep2

Obrigado pelo seu interesse! Este guia tem o essencial para contribuir.

## Reportando bugs

Abra uma [issue](https://github.com/vitoramaral10/flutter_cep2/issues) usando o template de bug report. Inclua código mínimo que reproduz o problema, versão do `flutter_cep2`, e versão do Dart/Flutter.

## Sugerindo features

Abra uma [issue](https://github.com/vitoramaral10/flutter_cep2/issues) usando o template de feature request, ou comece uma [discussion](https://github.com/vitoramaral10/flutter_cep2/discussions) se quiser tirar dúvidas antes.

## Pull Requests

```bash
git clone https://github.com/SEU_USUARIO/flutter_cep2.git
cd flutter_cep2
dart pub get

# faça suas mudanças

dart format .
dart analyze
dart test
```

Abra o PR contra `main` com uma descrição clara do que mudou e por quê. Adicione testes para mudanças de comportamento e atualize o `CHANGELOG.md` quando aplicável.

## Commit messages

Usamos [Conventional Commits](https://www.conventionalcommits.org/). Formato:

```
type(scope?): subject
```

| Type       | Quando usar                              |
|------------|------------------------------------------|
| `feat`     | Nova funcionalidade                      |
| `fix`      | Correção de bug                          |
| `docs`     | Apenas documentação                      |
| `refactor` | Refatoração sem mudança de comportamento |
| `perf`     | Melhoria de performance                  |
| `test`     | Adicionar/ajustar testes                 |
| `chore`    | Build, deps, tooling                     |
| `ci`       | CI/CD                                    |

**Subject:** imperativo, minúsculo, sem ponto final, ≤ 50 chars.

**Exemplos:**
```
feat: add timeout option to search
fix: handle malformed XML response
docs: update README usage example
```

Há um git hook que valida o formato — instale com `bash scripts/setup-hooks.sh`.

## Código de Conduta

Veja [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

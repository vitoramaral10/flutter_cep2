# Contribuindo para o flutter_cep2

Obrigado pelo seu interesse em contribuir para o flutter_cep2! 🎉

Este documento fornece diretrizes e informações sobre como contribuir para o projeto.

## Como Contribuir

### 🐛 Reportando Bugs

Se você encontrou um bug, por favor:

1. Verifique se o bug já não foi reportado nas [Issues](https://github.com/vitoramaral10/flutter_cep2/issues)
2. Se não existe uma issue similar, crie uma nova issue incluindo:
   - Uma descrição clara do problema
   - Passos para reproduzir o bug
   - Comportamento esperado vs. comportamento atual
   - Versão do Flutter/Dart sendo utilizada
   - Dispositivo e sistema operacional (se relevante)
   - Código de exemplo mínimo que reproduz o problema

### 💡 Sugerindo Melhorias

Para sugestões de novas funcionalidades:

1. Verifique se a funcionalidade já não foi sugerida
2. Crie uma issue descrevendo:
   - O problema que a funcionalidade resolve
   - Como você imagina que deveria funcionar
   - Exemplos de uso
   - Por que seria útil para outros usuários

### 🔧 Enviando Pull Requests

1. **Fork** o repositório
2. **Clone** seu fork localmente:
   ```bash
   git clone https://github.com/SEU_USUARIO/flutter_cep2.git
   cd flutter_cep2
   ```

3. **Configure** o upstream:
   ```bash
   git remote add upstream https://github.com/vitoramaral10/flutter_cep2.git
   ```

4. **Crie** uma branch para sua funcionalidade:
   ```bash
   git checkout -b feature/nome-da-funcionalidade
   ```

5. **Instale** as dependências:
   ```bash
   flutter pub get
   cd example
   flutter pub get
   cd ..
   ```

6. **Faça** suas alterações seguindo as diretrizes de código

7. **Execute** os testes:
   ```bash
   flutter test
   ```

8. **Execute** a análise de código:
   ```bash
   flutter analyze
   ```

9. **Formate** o código:
   ```bash
   dart format .
   ```

10. **Commit** suas alterações:
    ```bash
    git add .
    git commit -m "feat: adiciona nova funcionalidade"
    ```

11. **Push** para seu fork:
    ```bash
    git push origin feature/nome-da-funcionalidade
    ```

12. **Crie** um Pull Request explicando suas alterações

## Diretrizes de Código

### 📝 Estilo de Código

- Use `dart format` para formatar o código
- Siga as [Dart Style Guidelines](https://dart.dev/guides/language/effective-dart/style)
- Use nomes descritivos para variáveis e funções
- Adicione comentários para lógicas complexas

### 🧪 Testes

- Todos os PRs devem incluir testes
- Mantenha a cobertura de testes alta (idealmente 100%)
- Use mocks para dependências externas
- Teste cenários de sucesso e erro

### 📚 Documentação

- Documente APIs públicas com comentários dartdoc
- Atualize o README.md se necessário
- Inclua exemplos de uso para novas funcionalidades
- Mantenha o CHANGELOG.md atualizado

### 🏗️ Estrutura do Commit

Use [Conventional Commits](https://conventionalcommits.org/) para mensagens de commit:

- `feat:` para novas funcionalidades
- `fix:` para correções de bugs
- `docs:` para mudanças na documentação
- `test:` para adicionar ou modificar testes
- `refactor:` para refatoração de código
- `style:` para mudanças de formatação
- `chore:` para tarefas de manutenção

Exemplos:
```
feat: adiciona suporte para timeout personalizado
fix: corrige erro de parsing XML com caracteres especiais
docs: atualiza exemplos no README
test: adiciona testes para validação de CEP
```

## Processo de Review

1. **Automático**: Verificações de CI/CD devem passar
2. **Manual**: Um mantenedor revisará o código
3. **Feedback**: Responda aos comentários e faça ajustes se necessário
4. **Merge**: Após aprovação, o PR será mesclado

## Desenvolvimento Local

### Pré-requisitos

- Flutter SDK (versão estável mais recente)
- Dart SDK 2.17.0 ou superior
- Git

### Configuração

1. Clone o repositório
2. Execute `flutter pub get`
3. Execute os testes: `flutter test`
4. Execute o exemplo: `cd example && flutter run`

### Estrutura do Projeto

```
lib/
├── flutter_cep2.dart          # Arquivo principal da biblioteca
└── src/
    └── flutter_cep2_base.dart  # Implementação principal
test/
└── flutter_cep2_test.dart     # Testes unitários
example/                       # Aplicativo de exemplo
```

## Dúvidas?

- Abra uma [Issue](https://github.com/vitoramaral10/flutter_cep2/issues) para perguntas
- Entre em contato: [vitoramaral10@hotmail.com](mailto:vitoramaral10@hotmail.com)

## Código de Conduta

Por favor, leia e siga nosso [Código de Conduta](CODE_OF_CONDUCT.md).

---

Obrigado por contribuir! 🚀

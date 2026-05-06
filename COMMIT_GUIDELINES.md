# 📝 Commit Guidelines

This project uses **Conventional Commits** to maintain a clean and organized commit history. This format enables automated changelog generation and semantic versioning.

## Format

```
type(scope?): subject

body?

footer?
```

## Types

| Type | Description | Version |
|------|-------------|---------|
| `feat` | A new feature | Minor ↑ |
| `fix` | A bug fix | Patch ↑ |
| `docs` | Documentation only changes | Patch ↑ |
| `style` | Changes that don't affect code (formatting, whitespace) | Patch ↑ |
| `refactor` | Code change that neither fixes a bug nor adds a feature | Patch ↑ |
| `perf` | Code change that improves performance | Patch ↑ |
| `test` | Adding missing tests or correcting existing tests | - |
| `chore` | Changes to build process, dependencies, tooling | - |
| `ci` | Changes to CI/CD configuration files | - |
| `revert` | Reverts a previous commit | - |

## Scope (Optional)

The scope specifies what part of the codebase is affected:

```
feat(api): add new endpoint
fix(ui): correct button alignment
docs(readme): add installation instructions
```

Common scopes in this project:
- `api` - API functionality
- `ui` - User interface
- `test` - Test files
- `build` - Build/packaging
- `docs` - Documentation

## Subject

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize the first letter
- No period (.) at the end
- Limit to 50 characters

## Body (Optional)

- Wrap at 72 characters
- Explain **what** and **why**, not how
- Separate from subject with a blank line

## Footer (Optional)

- Reference issues and breaking changes
- Format: `Closes #123` or `Fixes #456`
- For breaking changes: `BREAKING CHANGE: description`

## Examples

### ✅ Good Examples

```
feat(auth): add login functionality

Implement JWT-based authentication system with:
- User registration and login
- Token refresh mechanism
- Session management

Closes #42
```

```
fix: correct typo in README
```

```
docs(api): update endpoint documentation
```

```
ci: add GitHub Actions workflow
```

```
refactor(parser): improve code readability

Split large function into smaller, focused functions
for better maintainability.
```

### ❌ Bad Examples

```
Fixed bug                           # ❌ Vague type, not following format
added new feature                   # ❌ Not using type prefix
Update dependencies.                # ❌ No type, has period
feat: ADDED LOGIN SCREEN            # ❌ Wrong case, "added" not imperative
fix(#123): resolve issue            # ❌ Issue number in wrong place
```

## Automatic Validation

This project uses Git hooks to validate commit messages locally:

```bash
# The commit-msg hook will run automatically
# If your message doesn't follow the format, the commit will be rejected:

❌ Commit message does not follow Conventional Commits format!

Format: type(scope?): subject

Valid types:
  • feat:     A new feature
  • fix:      A bug fix
  ...
```

## Benefits

✅ **Automated Changelog**: Commits are automatically categorized  
✅ **Semantic Versioning**: Version bumps are calculated automatically  
✅ **Clear History**: Easy to understand what changed and why  
✅ **Better Communication**: Clear intent in commit messages  
✅ **Automated Publishing**: Triggers pub.dev publication on merge  

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

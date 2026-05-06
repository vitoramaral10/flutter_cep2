# 🛠️ Development Guide - flutter_cep2

This guide helps you set up a local development environment and contribute to flutter_cep2.

**Last updated:** 2026-05-06

---

## 📋 Prerequisites

Before starting, ensure you have:

- **Git** (version 2.25+)
  ```bash
  git --version
  ```

- **Dart SDK** (version 3.0+)
  ```bash
  dart --version
  ```
  Or if using Flutter, Dart is included:
  ```bash
  flutter --version
  ```

- **Flutter SDK** (optional, for running example app)
  ```bash
  flutter --version
  ```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/vitoramaral10/flutter_cep2.git
cd flutter_cep2

# Or if you forked it:
git clone https://github.com/YOUR_USERNAME/flutter_cep2.git
cd flutter_cep2
```

### 2. Install Dependencies

```bash
# Get all dependencies
dart pub get

# Or with Flutter
flutter pub get
```

### 3. Setup Git Hooks

Git hooks validate commit messages and prevent commits that don't follow Conventional Commits:

```bash
# Run the setup script
bash scripts/setup-hooks.sh

# Or manually install pre-commit hook
mkdir -p .husky
cp scripts/pre-commit .husky/pre-commit
chmod +x .husky/pre-commit
```

**What hooks do:**
- ✅ Validate commit message format
- ✅ Prevent non-conventional commits
- ✅ Automatically fix formatting issues

### 4. Verify Setup

```bash
# Run all verification steps
dart test                          # Run tests
dart analyze --fatal-infos        # Static analysis
dart format --set-exit-if-changed . # Check formatting
```

All commands should pass without errors.

---

## 📁 Project Structure

```
flutter_cep2/
├── lib/                           # Main library code
│   ├── flutter_cep2.dart         # Main entry point
│   ├── src/
│   │   ├── models/               # Data models (CepResult, etc)
│   │   ├── exceptions/           # Custom exceptions
│   │   └── services/             # CEP lookup services
│   └── flutter_cep2_base.dart    # Base implementation
│
├── test/                          # Test files (mirror lib/)
│   ├── flutter_cep2_test.dart
│   └── src/
│
├── example/                       # Example Flutter app
│   ├── lib/
│   │   └── main.dart
│   ├── web/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── .github/                       # GitHub Actions workflows
│   ├── workflows/
│   │   ├── test.yml
│   │   ├── release.yml
│   │   ├── publish.yml
│   │   ├── code-review.yml
│   │   └── sonarcloud.yml
│   ├── ISSUE_TEMPLATE/
│   └── pull_request_template.md
│
├── scripts/                       # Development scripts
│   ├── setup-hooks.sh            # Setup Git hooks
│   ├── pre-commit                # Pre-commit hook
│   └── commit-msg                # Commit message validation
│
├── .husky/                        # Git hooks directory (created by setup)
├── pubspec.yaml                   # Package manifest
├── pubspec.lock                   # Locked dependencies
├── analysis_options.yaml          # Dart linter rules
├── dart_code_metrics.yaml         # Code metrics config
├── CHANGELOG.md                   # Version history
├── README.md                      # Package overview
├── CONTRIBUTING.md                # Contribution guidelines
├── SECURITY.md                    # Security policy
├── ROADMAP.md                     # Future plans
└── MAINTAINERS.md                 # Maintainer roles
```

---

## 🧪 Running Tests

### Run All Tests

```bash
# Run all tests
dart test

# Run with verbose output
dart test -v

# Run specific test file
dart test test/flutter_cep2_test.dart
```

### Run Tests with Coverage

```bash
# Generate coverage data
dart test --coverage=coverage

# Format coverage for viewing
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info

# View coverage report (if you have lcov installed)
lcov --summary coverage/lcov.info
```

### Watch Mode (Auto-run on Changes)

```bash
# Using dart test watcher
dart test --watch
```

---

## 🔍 Code Quality & Linting

### Format Code

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/flutter_cep2.dart

# Check formatting (don't change files)
dart format --set-exit-if-changed .
```

### Static Analysis

```bash
# Run analyzer with strict settings
dart analyze --fatal-infos

# View all issues (including warnings)
dart analyze
```

### Code Metrics

```bash
# Analyze code metrics
dart pub global activate dart_code_metrics
dart pub global run dart_code_metrics:metrics analyze lib --set-exit-on-violation-level=warning

# View detailed metrics report
dart pub global run dart_code_metrics:metrics analyze lib --reporter=json
```

---

## 🏃 Running the Example App

The `example/` directory contains a complete Flutter app demonstrating usage:

### Web

```bash
# Run example on web (hot reload enabled)
cd example
flutter run -d web

# Or specify Chrome
flutter run -d chrome
```

### Android

```bash
cd example

# List connected Android devices
flutter devices

# Run on emulator
flutter run -d emulator-5554

# Run on physical device
flutter run
```

### iOS

```bash
cd example

# Run on iOS simulator
flutter run -d ios

# Run on physical device (requires Apple Developer account)
flutter run
```

### Desktop (Windows/macOS/Linux)

```bash
cd example

# Check available platforms
flutter devices

# Run on Windows
flutter run -d windows

# Run on macOS
flutter run -d macos

# Run on Linux
flutter run -d linux
```

---

## 🐛 Debugging

### Debug Mode

```bash
# Run in debug mode with debug breakpoints
flutter run

# Then in IDE, set breakpoints and step through code
```

### Hot Reload

While the app is running:
- Press `r` to reload
- Press `R` for full restart
- Press `q` to quit

### Enable Debug Logs

```dart
// In your code
import 'package:flutter/foundation.dart';

void main() {
  // Print more debug info
  debugPrintBeginFrameBanner = true;
  debugPrintEndFrameBanner = true;
  
  runApp(MyApp());
}
```

### Verbose Logging

```bash
flutter run -v  # Verbose output
flutter test -v # Test verbose output
```

---

## 📝 Making Changes

### 1. Create a Feature Branch

```bash
# Update main branch first
git checkout main
git pull origin main

# Create feature branch
git checkout -b feat/your-feature-name

# Or for fixes
git checkout -b fix/your-bug-name

# Or for docs
git checkout -b docs/your-doc-name
```

### 2. Make Your Changes

- Edit files in `lib/` for library code
- Add tests in `test/`
- Update docs if needed

### 3. Test Your Changes

```bash
# Format code
dart format .

# Analyze
dart analyze --fatal-infos

# Run tests
dart test
```

### 4. Commit Your Changes

Follow [Conventional Commits](COMMIT_GUIDELINES.md):

```bash
# Good examples:
git commit -m "feat: add cache support for CEP lookups"
git commit -m "fix: handle invalid CEP format properly"
git commit -m "docs: improve API documentation"
git commit -m "test: add tests for error cases"
git commit -m "ci: improve GitHub Actions workflow"
```

### 5. Push to Your Fork

```bash
git push origin feat/your-feature-name
```

### 6. Create a Pull Request

Open a PR on GitHub with:
- Clear description of changes
- Link to related issues
- Checklist items completed
- Test coverage for new code

---

## 🔧 Common Development Tasks

### Add a New Function/Class

1. Create in `lib/src/` with proper structure
2. Export from `lib/flutter_cep2.dart`
3. Add tests in `test/src/`
4. Run full test suite
5. Update `CHANGELOG.md`
6. Update `README.md` if user-facing

### Update Dependencies

```bash
# Check for outdated packages
dart pub outdated

# Upgrade dependencies
dart pub upgrade

# Upgrade to latest (including breaking changes)
dart pub upgrade --major-versions

# Add new dependency
dart pub add package_name

# Add dev dependency
dart pub add --dev package_name
```

### Update Documentation

Documentation lives in:
- `README.md` - Main overview
- `CHANGELOG.md` - Version history
- `CONTRIBUTING.md` - How to contribute
- `SECURITY.md` - Security policy
- `ROADMAP.md` - Future plans
- `MAINTAINERS.md` - Governance
- Inline docs - Code comments & dartdoc

```bash
# Dartdoc: Generate documentation
dart doc

# View generated docs
# Open doc/api/index.html in browser
```

---

## 🚨 Troubleshooting

### Issue: "pub get" fails

**Solution:**
```bash
# Clear pub cache
dart pub cache clean

# Get dependencies again
dart pub get
```

### Issue: Tests fail with "No such file or directory"

**Solution:**
```bash
# Make sure you're in project root
pwd  # Should show path/to/flutter_cep2

# Run from project root
dart test
```

### Issue: "Permission denied" when running scripts

**Solution:**
```bash
# Make script executable
chmod +x scripts/setup-hooks.sh
chmod +x scripts/pre-commit

# Then run again
bash scripts/setup-hooks.sh
```

### Issue: Git hooks not running

**Solution:**
```bash
# Check if hooks are installed
ls -la .husky/

# Re-run setup
bash scripts/setup-hooks.sh

# Make sure hooks are executable
chmod +x .husky/pre-commit
chmod +x .husky/commit-msg
```

### Issue: Dart format complains about line length

**Solution:**
```bash
# This is expected - flutter_cep2 follows Dart conventions
# Either update your IDE settings to match analysis_options.yaml
# Or just run: dart format .
# The formatter will fix line length issues
```

### Issue: SonarCloud analysis shows issues locally

**Solution:**
```bash
# Install analysis tools locally (optional)
dart pub global activate dart_code_metrics

# Run metrics locally
dart pub global run dart_code_metrics:metrics analyze lib

# This mirrors what SonarCloud checks
```

### Issue: Example app won't build

**Solution:**
```bash
# Clean build cache
flutter clean

# Get dependencies again
flutter pub get

# Run again
flutter run
```

---

## 📊 Development Workflow

### Before Pushing

```bash
# 1. Format code
dart format .

# 2. Run static analysis
dart analyze --fatal-infos

# 3. Run tests
dart test

# 4. Run code metrics
dart pub global run dart_code_metrics:metrics analyze lib

# 5. Check git status
git status

# 6. Review changes
git diff

# 7. Commit
git commit -m "type(scope): description"

# 8. Push
git push origin branch-name
```

### CI/CD Pipeline

When you push or open a PR, GitHub Actions automatically:
- ✅ Runs tests
- ✅ Checks code coverage (must be 80%+)
- ✅ Analyzes code with dart_code_metrics
- ✅ Checks code quality with SonarCloud
- ✅ Reviews formatting with dart format

All checks must pass before merge.

---

## 🤝 Getting Help

### Ask a Question

1. Check [README.md](README.md) and existing docs
2. Search [GitHub Issues](https://github.com/vitoramaral10/flutter_cep2/issues)
3. Check [GitHub Discussions](https://github.com/vitoramaral10/flutter_cep2/discussions)
4. Ask in a new Discussion post

### Report a Problem

1. Check if issue already exists
2. Create detailed bug report with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Dart/Flutter version
   - Code example
3. Open a GitHub Issue

### Contribute Code

1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Follow this development guide
3. Ensure all tests pass
4. Open a Pull Request

---

## 📚 Useful Resources

### Documentation
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Documentation](https://flutter.dev/docs)
- [Pub.dev Package Documentation](https://pub.dev/packages/flutter_cep2)
- [Conventional Commits](https://www.conventionalcommits.org/)

### Tools
- [Dart Analysis](https://dart.dev/guides/language/analysis-options)
- [dart_code_metrics](https://dartcodemetrics.dev/)
- [SonarCloud](https://sonarcloud.io/)

### Testing
- [Dart Testing Guide](https://dart.dev/guides/testing)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)

---

## 🎓 Learning More

Want to understand the codebase better?

1. **Start here:** `lib/flutter_cep2.dart` - Main entry point
2. **Then:** `lib/src/models/` - Data structures
3. **Services:** `lib/src/services/` - Business logic
4. **Tests:** `test/` - See how features are tested
5. **Examples:** `example/lib/main.dart` - Real usage

---

**Happy coding! 🚀**

Questions? Open a [Discussion](https://github.com/vitoramaral10/flutter_cep2/discussions) or [Issue](https://github.com/vitoramaral10/flutter_cep2/issues).

Last updated: 2026-05-06  
Next review: 2026-06-06

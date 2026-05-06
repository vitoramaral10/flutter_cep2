# 🤖 Dependabot Configuration - flutter_cep2

This document explains our automated dependency management strategy using GitHub Dependabot.

**Last updated:** 2026-05-06

---

## 📋 Overview

Dependabot automatically:
- 🔄 Checks for dependency updates weekly
- 📦 Creates pull requests for updates
- 🔒 Identifies security vulnerabilities
- ✅ Auto-merges low-risk updates
- 📊 Keeps dependencies fresh and secure

---

## 🎯 Update Schedule

### Main Package Dependencies
- **Frequency:** Weekly (Mondays at 03:00 UTC)
- **Limit:** 5 open PRs max
- **Auto-merge:** Yes (patch updates)
- **Strategy:** Rebase and merge

### Example App Dependencies
- **Frequency:** Weekly (Mondays at 04:00 UTC)
- **Limit:** 3 open PRs max
- **Auto-merge:** Yes
- **Strategy:** Rebase and merge

### GitHub Actions
- **Frequency:** Weekly (Mondays at 05:00 UTC)
- **Limit:** 5 open PRs max
- **Auto-merge:** Yes
- **Strategy:** Rebase and merge

---

## 🔒 Dependency Types

Dependabot monitors:

### 1. **Direct Dependencies**
Dependencies explicitly listed in `pubspec.yaml`:
- `http` - HTTP client
- `test` - Testing framework
- Others as needed

**Risk Level:** Medium  
**Review:** Each update reviewed

### 2. **Indirect Dependencies** (Transitive)
Dependencies of our dependencies:
- Automatically managed by Dependabot
- Analyzed for vulnerabilities
- May be auto-merged if safe

**Risk Level:** Low-Medium  
**Review:** High-risk updates flagged

### 3. **Development Dependencies**
Tools used only in development:
- `test` framework
- `coverage` for metrics
- Build tools

**Risk Level:** Low  
**Review:** Can be auto-merged

---

## 🚨 Security Vulnerabilities

### When a Security Issue is Found

1. **Dependabot creates a Security Alert**
   - Shows severity (critical, high, medium, low)
   - Links to CVE information
   - Suggests fixed version

2. **PR is Created Automatically**
   - Label: `dependencies`, `security` (if critical)
   - Priority: High for critical/high
   - Auto-merged if tests pass

3. **Timeline**
   - Critical: Fixed immediately (same day)
   - High: Fixed within 48 hours
   - Medium: Fixed within 1 week
   - Low: Included in regular updates

---

## 📊 Dashboard & Monitoring

### Where to Monitor

1. **GitHub Security Tab**
   - Navigate to: `Settings > Code Security & Analysis > Dependabot`
   - View: Alerts, dependency graph, update history

2. **Pull Requests Tab**
   - Filter by label: `dependencies`
   - View: Pending, merged, closed updates
   - Status: Checks, coverage, review status

3. **Commit History**
   - Search for: `chore(deps):` commits
   - View: Dependency update timeline
   - Compare: Before/after versions

### Key Metrics

Track these metrics monthly:

| Metric | Target | Current |
|--------|--------|---------|
| Security Alerts | 0 | TBD |
| Outdated Packages | <3 | TBD |
| Update PRs/Month | 8-12 | TBD |
| Auto-Merge Rate | 80%+ | TBD |
| Merge Time (avg) | <24h | TBD |

---

## ⚙️ Auto-Merge Strategy

### What Gets Auto-Merged

✅ **Automatically merged:**
- Patch version updates (1.2.3 → 1.2.4)
- GitHub Actions updates
- Development dependencies
- Updates that pass all checks

### What Needs Manual Review

🔍 **Requires review:**
- Minor version updates (1.2 → 1.3)
- Major version updates (1.0 → 2.0)
- Breaking changes in changelogs
- Complex transitive updates
- Security updates (high/critical severity)

### Auto-Merge Conditions

PR must meet ALL criteria:
- ✅ All status checks pass (tests, coverage, analysis)
- ✅ No conflicts with main branch
- ✅ No failing reviews
- ✅ Only patch-level update (or low-risk minor)
- ✅ No security vulnerabilities introduced

---

## 🔄 Workflow

### For Developers

1. **Dependabot PR Arrives**
   - Auto-labeled with `dependencies`
   - CI runs automatically
   - Auto-merged if safe (usually 5-10 min)

2. **For Manual Updates**
   - Read PR description
   - Check changelog/breaking changes
   - Review added code if needed
   - Approve and merge

3. **If Tests Fail**
   - Investigate failure
   - Update code if needed
   - Push to Dependabot PR (it rebases)
   - Tests run again

### For Maintainers

**Weekly Checklist (every Monday):**
1. Review security alerts on GitHub
2. Check dashboard for pending PRs
3. Investigate any failed updates
4. Approve high-risk updates manually
5. Document any dependency changes

---

## 🛠️ Common Tasks

### Manually Check for Updates

```bash
# Check outdated packages
dart pub outdated

# Interactive update
dart pub upgrade --interactive

# Get latest (including breaking)
dart pub upgrade --major-versions
```

### Update Specific Package

```bash
# Update one package
dart pub upgrade package_name

# Add new dependency
dart pub add package_name

# Update to specific version
dart pub add 'package_name:^2.0.0'
```

### View Dependency Graph

```bash
# In browser, visit:
# https://github.com/vitoramaral10/flutter_cep2/network/dependencies

# Or use command line:
dart pub deps
dart pub deps --style=compact
dart pub deps --style=list
```

---

## 🚨 Troubleshooting

### Issue: Dependabot PR has conflicts

**Solution:**
- Rebase from main: `git rebase main`
- Dependabot will automatically rebase if enabled
- Conflicts usually resolve automatically

### Issue: Update breaks tests

**Solution:**
1. Check what changed in the update
2. Update code to handle breaking change
3. Push to PR branch
4. Tests run again automatically
5. Once passing, PR auto-merges

### Issue: Dependabot is creating too many PRs

**Solution:**
```yaml
# In dependabot.yml, reduce frequency or increase limit:
open-pull-requests-limit: 3  # Lower this
# Or change schedule:
schedule:
  interval: "monthly"  # Change from weekly
```

### Issue: Want to skip a dependency update

**Solution:**
You can use `@dependabot ignore` comment in PR:
```
@dependabot ignore this major version
@dependabot ignore this dependency
@dependabot recreate
```

---

## 📚 Best Practices

### Do's ✅

- ✅ Keep dependencies up-to-date
- ✅ Review security alerts promptly
- ✅ Auto-merge safe patch updates
- ✅ Test after updates
- ✅ Document breaking changes
- ✅ Monitor dependency health

### Don'ts ❌

- ❌ Ignore security alerts
- ❌ Force-merge failing tests
- ❌ Disable Dependabot
- ❌ Allow too many outdated packages
- ❌ Skip reviewing major updates
- ❌ Use insecure dependency versions

---

## 🔐 Security Considerations

### Dependency Vulnerabilities

Each dependency is scanned for:
- **Known Security Issues** (CVE database)
- **License Compliance** (Apache 2.0, MIT, etc)
- **Malware Detection** (Dependabot Security)

### Response Plan

If vulnerability found:
1. **Critical**: Fix immediately (today)
2. **High**: Fix within 48 hours
3. **Medium**: Fix within 1 week
4. **Low**: Include in next release

### Reporting Security Issues

If you find a vulnerability:
1. **DO NOT** create a public issue
2. Email: vitor.amaral10@gmail.com
3. Subject: `[SECURITY] Vulnerability in dependency X`
4. Wait for private disclosure

---

## 📖 Resources

### Documentation
- [Dependabot Docs](https://docs.github.com/en/code-security/dependabot)
- [Pub.dev Security](https://pub.dev/help)
- [Dart Security](https://dart.dev/security)

### Tools
- [Dependency Dashboard](https://github.com/vitoramaral10/flutter_cep2/security/dependabot)
- [GitHub Alerts](https://github.com/vitoramaral10/flutter_cep2/security)
- [Pub.dev Package](https://pub.dev/packages/flutter_cep2)

### External
- [CVE Database](https://cve.mitre.org/)
- [NVD - National Vulnerability Database](https://nvd.nist.gov/)

---

## 🔄 Configuration Files

### `.github/dependabot.yml`
Main configuration file for Dependabot:
- Update schedules
- Auto-merge rules
- Labels and assignees
- Commit message format

### `pubspec.yaml` & `pubspec.lock`
Dart dependency files:
- `pubspec.yaml`: Declared dependencies
- `pubspec.lock`: Pinned versions (auto-updated)

### `analysis_options.yaml`
Dart linter rules (separate from dependencies)

---

## 📞 Questions?

- 📖 Read [DEVELOPMENT.md](DEVELOPMENT.md) for setup
- 💬 Ask in [Discussions](https://github.com/vitoramaral10/flutter_cep2/discussions)
- 🐛 Report issues: [GitHub Issues](https://github.com/vitoramaral10/flutter_cep2/issues)
- 🔒 Security: [vitor.amaral10@gmail.com](mailto:vitor.amaral10@gmail.com)

---

**Last updated:** 2026-05-06  
**Next review:** 2026-06-06

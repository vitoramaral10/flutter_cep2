# 📝 Release Notes Generator - flutter_cep2

This guide explains how to generate release notes for flutter_cep2 releases.

**Last updated:** 2026-05-06

---

## 🎯 Overview

The Release Notes Generator automatically creates well-formatted release notes from git commits using Conventional Commits format.

**Features:**
- 🤖 Automatic categorization of commits
- 📋 Well-formatted markdown output
- 🔗 Links to commit hashes
- 📊 Summary of changes by type
- ⚙️ Can run locally or via GitHub Actions

---

## 🚀 Quick Start

### Local Generation

```bash
# Generate for current version (reads from pubspec.yaml)
bash scripts/generate-release-notes.sh

# Generate for specific version
bash scripts/generate-release-notes.sh 1.0.2
```

### Via GitHub Actions

1. Go to: **Actions** → **Generate Release Notes**
2. Click: **Run workflow**
3. Enter version: `1.0.2`
4. Click: **Run workflow**
5. Download artifact: `release-notes`

---

## 📖 How It Works

### Commit Categorization

The script reads commits since the last tag and categorizes them:

| Type | Symbol | Description |
|------|--------|-------------|
| `feat` | ✨ | New features |
| `fix` | 🐛 | Bug fixes |
| `docs` | 📚 | Documentation |
| `breaking` | 🚨 | Breaking changes |
| other | 🔧 | Other changes |

### Conventional Commits Format

Release notes work best with Conventional Commits:

```
type(scope): description

type: feat, fix, docs, style, refactor, perf, test, chore, ci, revert
scope: optional (e.g., api, cli, core)
description: what changed
```

**Examples:**
```
feat(api): add caching support
fix: handle null CEP input
docs: update README examples
```

---

## 📝 Output Format

Generated release notes follow this structure:

```markdown
## Release X.Y.Z - YYYY-MM-DD

### 🚨 Breaking Changes
- Change description [hash](link)

### ✨ Features
- Feature description [hash](link)

### 🐛 Bug Fixes
- Fix description [hash](link)

### 📚 Documentation
- Docs description [hash](link)

### 🔧 Other Changes
- Other description [hash](link)

**Full Changelog**: [vX.Y.Z-1...vX.Y.Z](link)
```

---

## 💻 Local Usage

### Prerequisites

```bash
# Check you have git
git --version

# Should output version 2.25+
```

### Step-by-Step

1. **Ensure you're in project root**
   ```bash
   cd flutter_cep2
   ```

2. **Make script executable**
   ```bash
   chmod +x scripts/generate-release-notes.sh
   ```

3. **Generate notes**
   ```bash
   # Current version from pubspec.yaml
   bash scripts/generate-release-notes.sh

   # Or specific version
   bash scripts/generate-release-notes.sh 1.0.2
   ```

4. **Output**
   - File created: `RELEASE_NOTES_1.0.2.md`
   - Preview shown in terminal
   - Ready to use or edit

### Examples

```bash
# Generate for version in pubspec.yaml
bash scripts/generate-release-notes.sh

# Generate for specific version
bash scripts/generate-release-notes.sh 1.1.0

# Save to custom file
bash scripts/generate-release-notes.sh 1.0.2 > my-notes.md
```

---

## ⚙️ GitHub Actions Workflow

### Trigger the Workflow

1. **Navigate to Actions tab**
   - URL: `https://github.com/vitoramaral10/flutter_cep2/actions`

2. **Select "Generate Release Notes"**
   - Left sidebar → "Generate Release Notes"

3. **Click "Run workflow"**
   - Button appears on right side
   - Opens input dialog

4. **Enter version**
   - Must be semantic version: X.Y.Z
   - Example: `1.0.2`

5. **Click "Run workflow"**
   - Workflow starts
   - Takes ~30 seconds

6. **Wait for completion**
   - Green checkmark = success
   - Red X = failed

7. **Download artifact**
   - Click on workflow run
   - "Artifacts" section
   - Download `release-notes.zip`
   - Extract to get `RELEASE_NOTES_1.0.2.md`

### What the Workflow Does

1. ✅ Validates version format
2. ✅ Runs generate script
3. ✅ Uploads artifact
4. ✅ Creates summary with preview

---

## 📋 Manual Review

### Before Publishing

Always review generated notes:

1. **Check accuracy**
   - Are all changes included?
   - Correct categorization?
   - Any missing commits?

2. **Edit if needed**
   - Fix descriptions
   - Add context
   - Reorder if important

3. **Validate format**
   - Markdown is valid
   - Links work
   - No typos

### Common Edits

```markdown
# Before
- handle input properly [a1b2c3d](...)

# After (more descriptive)
- Fix CEP validation to handle different input formats [a1b2c3d](...)
```

---

## 🔗 Integration with Releases

### Copy to GitHub Release

1. **Generate notes**
   ```bash
   bash scripts/generate-release-notes.sh 1.0.2
   ```

2. **Open GitHub Release**
   - Go to: **Releases** → **Draft a new release**
   - Or edit existing release

3. **Copy content**
   - Open `RELEASE_NOTES_1.0.2.md`
   - Copy all content
   - Paste in Release description

4. **Publish**
   - Click "Publish release"
   - Users see formatted notes

---

## 🎨 Customization

### Modify Categories

Edit `scripts/generate-release-notes.sh`:

```bash
# Change emoji for features
case $TYPE in
  feat)
    # Change ✨ to something else
    FEATURES+="- $MESSAGE ..."
    ;;
esac
```

### Change Commit Order

Reorder sections in script:

```bash
# Currently: Breaking → Features → Fixes → Docs → Other
# Change order by moving these blocks:
RELEASE_NOTES+="### 🚨 Breaking Changes"
RELEASE_NOTES+="### ✨ Features"
etc.
```

### Add New Category

```bash
# In categorization switch statement
feat-api)
  APIS+="- $MESSAGE ..."
  ;;

# Then in output section
if [[ -n $APIS ]]; then
  RELEASE_NOTES+="### 🌐 API Changes"$'\n'
  RELEASE_NOTES+=$APIS
fi
```

---

## 🔍 Troubleshooting

### Issue: "No previous tags found"

**Cause:** First release, no git tags exist

**Solution:**
- This is normal for v1.0.0
- Script includes all commits
- Verify output includes expected changes

### Issue: Commits not appearing

**Cause:** Commits don't follow Conventional Commits format

**Solution:**
```bash
# Check git log format
git log --oneline | head -10

# Should look like:
# a1b2c3d feat: add new feature
# d4e5f6g fix: fix bug
# h7i8j9k docs: update docs
```

If commits are not conventional, they appear in "Other Changes" or not at all.

### Issue: Script permission denied

**Cause:** Script not executable

**Solution:**
```bash
chmod +x scripts/generate-release-notes.sh
```

### Issue: Version validation fails

**Cause:** Invalid version format

**Solution:**
```bash
# Valid formats:
1.0.0    ✅
1.0.2    ✅
1.1.0    ✅
v1.0.0   ❌ (don't include 'v')
1.0      ❌ (need patch version)
latest   ❌ (must be numeric)
```

---

## 📚 Best Practices

### For Developers

✅ **Do:**
- Use Conventional Commits in all PRs
- Include type and scope
- Write descriptive messages
- Reference issues when relevant

❌ **Don't:**
- Mix commit types in one PR
- Use vague descriptions
- Forget commit type
- Create ambiguous messages

### For Maintainers

✅ **Do:**
- Generate notes before release
- Review for accuracy
- Edit for clarity if needed
- Keep consistent format

❌ **Don't:**
- Skip review
- Publish without checking
- Mix formats
- Forget comparison link

---

## 🔄 Release Workflow

### Complete Release Process

1. **Create release PR**
   - Update version in pubspec.yaml
   - Update CHANGELOG.md
   - Create pull request

2. **Merge to main**
   - Wait for all checks
   - Merge release PR
   - Automatic tag created

3. **Generate release notes**
   ```bash
   bash scripts/generate-release-notes.sh
   ```

4. **Create GitHub Release**
   - Go to Releases
   - Draft new release
   - Tag: `v1.0.2`
   - Copy generated notes
   - Publish

5. **Announce release**
   - Discussions
   - Twitter/social media
   - Email newsletter (if applicable)

---

## 📞 Questions?

- 📖 Read [DEVELOPMENT.md](DEVELOPMENT.md)
- 💬 Ask in [Discussions](https://github.com/vitoramaral10/flutter_cep2/discussions)
- 🐛 Report issues: [GitHub Issues](https://github.com/vitoramaral10/flutter_cep2/issues)

---

**Last updated:** 2026-05-06  
**Next review:** 2026-06-06

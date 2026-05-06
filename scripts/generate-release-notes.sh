#!/bin/bash

# Generate Release Notes for flutter_cep2
# Usage: bash scripts/generate-release-notes.sh [version]
# Example: bash scripts/generate-release-notes.sh 1.0.2

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get version from argument or current version in pubspec.yaml
if [[ $# -gt 0 ]]; then
  VERSION=$1
else
  VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
fi

echo -e "${BLUE}🔍 Generating release notes for version ${VERSION}${NC}"

# Check if version is valid (semantic versioning)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${RED}❌ Invalid version format: $VERSION${NC}"
  echo "Expected format: X.Y.Z (semantic versioning)"
  exit 1
fi

# Get git tags
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
CURRENT_TAG="v$VERSION"

if [[ -z $LATEST_TAG ]]; then
  echo -e "${YELLOW}⚠️  No previous tags found${NC}"
  COMMITS="$(git log --oneline --all)"
else
  echo -e "${BLUE}📦 Previous tag: $LATEST_TAG${NC}"
  COMMITS="$(git log $LATEST_TAG..$CURRENT_TAG --oneline 2>/dev/null || git log --oneline -n 20)"
fi

# Parse conventional commits
FEATURES=""
FIXES=""
BREAKING=""
DOCS=""
OTHERS=""

while IFS= read -r commit; do
  # Skip empty lines
  [[ -z "$commit" ]] && continue

  # Extract commit type and message
  if [[ $commit =~ ^[a-f0-9]+\ ([a-z]+)(\([^)]+\))?:\ (.+)$ ]]; then
    TYPE="${BASH_REMATCH[1]}"
    SCOPE="${BASH_REMATCH[2]}"
    MESSAGE="${BASH_REMATCH[3]}"
    HASH=$(echo $commit | awk '{print $1}')
    SHORT_HASH="${HASH:0:7}"

    # Categorize commits
    case $TYPE in
      feat)
        FEATURES+="- $MESSAGE ([$SHORT_HASH](https://github.com/vitoramaral10/flutter_cep2/commit/$HASH))"$'\n'
        ;;
      fix)
        FIXES+="- $MESSAGE ([$SHORT_HASH](https://github.com/vitoramaral10/flutter_cep2/commit/$HASH))"$'\n'
        ;;
      docs)
        DOCS+="- $MESSAGE ([$SHORT_HASH](https://github.com/vitoramaral10/flutter_cep2/commit/$HASH))"$'\n'
        ;;
      *)
        if [[ $commit == *"BREAKING"* ]] || [[ $MESSAGE == *"BREAKING"* ]]; then
          BREAKING+="- $MESSAGE ([$SHORT_HASH](https://github.com/vitoramaral10/flutter_cep2/commit/$HASH))"$'\n'
        else
          OTHERS+="- $MESSAGE ([$SHORT_HASH](https://github.com/vitoramaral10/flutter_cep2/commit/$HASH))"$'\n'
        fi
        ;;
    esac
  fi
done <<< "$COMMITS"

# Get date
RELEASE_DATE=$(date +%Y-%m-%d)

# Create release notes
RELEASE_NOTES=""

RELEASE_NOTES+="## Release $VERSION - $RELEASE_DATE"$'\n'
RELEASE_NOTES+=$'\n'

# Add breaking changes first (most important)
if [[ -n $BREAKING ]]; then
  RELEASE_NOTES+="### 🚨 Breaking Changes"$'\n'
  RELEASE_NOTES+=$BREAKING
  RELEASE_NOTES+=$'\n'
fi

# Add features
if [[ -n $FEATURES ]]; then
  RELEASE_NOTES+="### ✨ Features"$'\n'
  RELEASE_NOTES+=$FEATURES
  RELEASE_NOTES+=$'\n'
fi

# Add fixes
if [[ -n $FIXES ]]; then
  RELEASE_NOTES+="### 🐛 Bug Fixes"$'\n'
  RELEASE_NOTES+=$FIXES
  RELEASE_NOTES+=$'\n'
fi

# Add documentation
if [[ -n $DOCS ]]; then
  RELEASE_NOTES+="### 📚 Documentation"$'\n'
  RELEASE_NOTES+=$DOCS
  RELEASE_NOTES+=$'\n'
fi

# Add other commits
if [[ -n $OTHERS ]]; then
  RELEASE_NOTES+="### 🔧 Other Changes"$'\n'
  RELEASE_NOTES+=$OTHERS
  RELEASE_NOTES+=$'\n'
fi

# Add comparison link
if [[ -n $LATEST_TAG ]]; then
  RELEASE_NOTES+="**Full Changelog**: [${LATEST_TAG}...v${VERSION}](https://github.com/vitoramaral10/flutter_cep2/compare/${LATEST_TAG}...v${VERSION})"$'\n'
fi

# Output to file
OUTPUT_FILE="RELEASE_NOTES_${VERSION}.md"

echo -e "${RELEASE_NOTES}" > "$OUTPUT_FILE"

echo -e "${GREEN}✅ Release notes generated!${NC}"
echo -e "${BLUE}📝 File: $OUTPUT_FILE${NC}"
echo ""
echo -e "${YELLOW}Preview:${NC}"
echo "---"
echo -e "${RELEASE_NOTES}"
echo "---"
echo ""
echo -e "${GREEN}You can now:${NC}"
echo "1. Copy the content above for GitHub Release"
echo "2. Review the generated file: $OUTPUT_FILE"
echo "3. Edit if needed before publishing"

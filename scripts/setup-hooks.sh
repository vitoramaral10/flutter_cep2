#!/bin/bash

# Setup Git Hooks for Conventional Commits validation
# This script configures pre-commit and commit-msg hooks

set -e

echo "📦 Setting up Git hooks..."

# Check if in git repository
if [[ ! -d .git ]]; then
    echo "❌ Error: Not in a Git repository" >&2
    exit 1
fi

# Make hook files executable
chmod +x .husky/pre-commit
chmod +x .husky/commit-msg

# Create git hook directory if it doesn't exist
mkdir -p .git/hooks

# Copy hooks to .git/hooks (git will use these)
cp .husky/pre-commit .git/hooks/pre-commit
cp .husky/commit-msg .git/hooks/commit-msg

# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg

echo "✅ Git hooks installed successfully!"
echo ""
echo "Installed hooks:"
echo "  • pre-commit: Format Dart code before committing"
echo "  • commit-msg: Validate commit message format"
echo ""
echo "📖 See CONTRIBUTING.md for commit message format"
echo ""
echo "Next time you commit, your message will be validated!"

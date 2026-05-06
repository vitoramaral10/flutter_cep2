#!/bin/bash

# Setup Git Hooks for Conventional Commits validation
# This script configures pre-commit and commit-msg hooks

set -e

echo "📦 Setting up Git hooks..."

# Make hook files executable
chmod +x .husky/pre-commit
chmod +x .husky/commit-msg

# Create git hook directory if it doesn't exist
mkdir -p .git/hooks

# Copy hooks to .git/hooks (git will use these)
cp .husky/pre-commit .git/hooks/pre-commit
cp .husky/commit-msg .git/hooks/commit-msg

chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg

echo "✅ Git hooks installed successfully!"
echo ""
echo "Installed hooks:"
echo "  • pre-commit: Format Dart code before committing"
echo "  • commit-msg: Validate commit message format"
echo ""
echo "Read COMMIT_GUIDELINES.md for more information"

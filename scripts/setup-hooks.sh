#!/usr/bin/env bash
# Points git at the versioned hooks in .githooks/.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
chmod +x .githooks/*
git config core.hooksPath .githooks
echo "Git hooks enabled (.githooks): pre-commit (format) and commit-msg (Conventional Commits)."

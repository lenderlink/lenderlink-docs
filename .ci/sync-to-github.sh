#!/usr/bin/env bash
# Sync the current Bitbucket commit to GitHub (lenderlink/lenderlink-docs).
#
# Required secured repository variable in Bitbucket:
#   GITHUB_TOKEN — GitHub PAT or fine-grained token with contents:write
#                  on lenderlink/lenderlink-docs
#
# Optional repository variables:
#   GITHUB_REPO  — defaults to lenderlink/lenderlink-docs
#   GITHUB_BRANCH — defaults to main

set -euo pipefail

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN is not set (add a secured Bitbucket repository variable)"
  exit 1
fi

GITHUB_REPO="${GITHUB_REPO:-lenderlink/lenderlink-docs}"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"
REMOTE_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git"

echo "Syncing ${BITBUCKET_COMMIT:-HEAD} → github.com/${GITHUB_REPO} (${GITHUB_BRANCH})"

git remote remove github 2>/dev/null || true
git remote add github "${REMOTE_URL}"

# Full history so GitHub can receive non-fast-forward history if needed.
git fetch --unshallow 2>/dev/null || true

git push github "HEAD:refs/heads/${GITHUB_BRANCH}"

# Propagate tags that exist on this commit / repo (best-effort).
git push github --tags || true

echo "GitHub sync complete."

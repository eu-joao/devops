#!/usr/bin/env bash
# Publica mudanças somente depois que o agente terminou.
set -euo pipefail
SLUG="${1:?uso: open-pr.sh <slug> <titulo> <arquivo-corpo>}"
TITLE="${2:?informe o título}"
BODY_FILE="${3:?informe o corpo do PR}"
: "${GH_TOKEN:?GH_TOKEN não definido}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY não definido}"
mkdir -p .git/info
printf '.agents/\n.agent-*\n' >> .git/info/exclude
if [ -z "$(git status --porcelain)" ]; then
  echo "Sem mudanças; nada a fazer."
  exit 0
fi
BASE_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
BRANCH="agent/${SLUG}-$(date +%Y%m%d-%H%M)"
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git remote set-url origin "https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git checkout -b "$BRANCH"
git add -A
git commit -m "$TITLE" -m "Gerado por agente de IA. Revise antes de aprovar."
git push -u origin "$BRANCH"
gh pr create --repo "$GITHUB_REPOSITORY" --base "$BASE_BRANCH" --head "$BRANCH" --title "$TITLE" --body-file "$BODY_FILE"

#!/usr/bin/env bash
# Cria branch, commit, push e Pull Request com as mudanças do diretório atual.
#
# Uso: open-pr.sh <slug> <titulo> <arquivo-com-corpo-do-pr>
#
# Variáveis de ambiente (já definidas pelo GitHub Actions, exceto GH_TOKEN):
#   GH_TOKEN             token com contents:write e pull-requests:write
#   GITHUB_REPOSITORY    dono/nome do repositório
#
# O token só entra aqui, depois que o agente terminou: durante a execução do
# agente o checkout não guarda credenciais (persist-credentials: false).

set -euo pipefail

SLUG="${1:?uso: open-pr.sh <slug> <titulo> <arquivo-com-corpo-do-pr>}"
TITLE="${2:?informe o título do PR}"
BODY_FILE="${3:?informe o arquivo com o corpo do PR}"

: "${GH_TOKEN:?GH_TOKEN não definido}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY não definido}"

# Arquivos do próprio mecanismo nunca entram no commit.
mkdir -p .git/info
printf '.agents/\n.agent-*\n' >> .git/info/exclude

if [ -z "$(git status --porcelain)" ]; then
  echo "Sem mudanças no repositório; nada a fazer."
  exit 0
fi

BASE_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
BRANCH="agent/${SLUG}-$(date +%Y%m%d-%H%M)"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git remote set-url origin "https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git checkout -b "$BRANCH"
git add -A
git commit -m "$TITLE" -m "Gerado por agente de IA no GitHub Actions. Revise antes de aprovar."
git push -u origin "$BRANCH"

gh pr create \
  --repo "$GITHUB_REPOSITORY" \
  --base "$BASE_BRANCH" \
  --head "$BRANCH" \
  --title "$TITLE" \
  --body-file "$BODY_FILE"

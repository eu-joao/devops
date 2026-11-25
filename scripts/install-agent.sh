#!/usr/bin/env bash
# Instala o CLI do agente escolhido no runner do GitHub Actions.
#
# Variáveis de ambiente:
#   AGENT_CLI       claude | codex | gemini | vibe   (padrão: claude)
#   AGENT_VERSION   versão do pacote (padrão: latest; fixe uma para builds repetíveis)

set -euo pipefail

AGENT_CLI="${AGENT_CLI:-claude}"
VERSION="${AGENT_VERSION:-latest}"
PREFIX="$HOME/.local"

case "$AGENT_CLI" in
  claude) npm install -g --prefix "$PREFIX" "@anthropic-ai/claude-code@${VERSION}" ;;
  codex)  npm install -g --prefix "$PREFIX" "@openai/codex@${VERSION}" ;;
  gemini) npm install -g --prefix "$PREFIX" "@google/gemini-cli@${VERSION}" ;;
  vibe)   pipx install mistral-vibe ;;
  *)
    echo "AGENT_CLI desconhecido: $AGENT_CLI (use claude, codex, gemini ou vibe)" >&2
    exit 1
    ;;
esac

# Deixa o CLI no PATH dos próximos passos do job.
if [ -n "${GITHUB_PATH:-}" ]; then
  echo "$PREFIX/bin" >> "$GITHUB_PATH"
fi

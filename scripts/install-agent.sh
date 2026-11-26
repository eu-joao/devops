#!/usr/bin/env bash
# Instala somente o CLI escolhido.
set -euo pipefail
PROVIDER="${AGENT_PROVIDER:-${AGENT_CLI:-mistral-vibe}}"
case "$PROVIDER" in
  mistral-vibe)
    python -m pip install --user --upgrade mistral-vibe
    ;;
  gemini)
    npm install -g @google/gemini-cli
    ;;
  *)
    echo "Provedor desconhecido: $PROVIDER (use mistral-vibe ou gemini)" >&2
    exit 2
    ;;
esac

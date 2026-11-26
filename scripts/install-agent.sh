#!/usr/bin/env bash
set -euo pipefail
PROVIDER="${AGENT_PROVIDER:-${AGENT_CLI:-mistral-vibe}}"
case "$PROVIDER" in
  mistral-vibe)
    pipx install --force mistral-vibe
    ;;
  gemini)
    npm install -g @google/gemini-cli
    ;;
  *)
    echo "Provedor desconhecido: $PROVIDER (use mistral-vibe ou gemini)" >&2
    exit 2
    ;;
esac

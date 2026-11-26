#!/usr/bin/env bash
set -euo pipefail
PROVIDER="${AGENT_PROVIDER:-mistral-vibe}"
case "$PROVIDER" in
  mistral-vibe)
    pipx install --force mistral-vibe
    if [ -n "${GITHUB_PATH:-}" ]; then echo "$HOME/.local/bin" >> "$GITHUB_PATH"; fi
    ;;
  gemini)
    npm install -g @google/gemini-cli
    ;;
  *)
    echo "Provedor desconhecido: $PROVIDER (use mistral-vibe ou gemini)" >&2
    exit 2
    ;;
esac

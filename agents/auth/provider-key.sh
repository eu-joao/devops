#!/usr/bin/env bash
set -euo pipefail
AGENT_PROVIDER="${AGENT_PROVIDER:-mistral-vibe}"
case "$AGENT_PROVIDER" in
  mistral-vibe) AGENT_PROVIDER_KEY="${MISTRAL_VIBE_CODE_KEY:-}" ;;
  gemini) AGENT_PROVIDER_KEY="${GEMINI_API_KEY:-}" ;;
  *) echo "AGENT_PROVIDER inválido: $AGENT_PROVIDER" >&2; exit 2 ;;
esac
export AGENT_PROVIDER_KEY

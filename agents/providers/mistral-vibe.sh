#!/usr/bin/env bash
set -euo pipefail
: "${AGENT_PROVIDER_KEY:?Chave Mistral Vibe ausente}"
args=(--prompt "$AGENT_PROMPT" --max-turns "${AGENT_MAX_TURNS:-12}" --output json)
if [ "${AGENT_MODE:-readonly}" = "edit" ]; then args+=(--auto-approve); fi
MISTRAL_API_KEY="$AGENT_PROVIDER_KEY" timeout "${AGENT_TIMEOUT:-900}" vibe "${args[@]}"

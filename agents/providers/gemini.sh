#!/usr/bin/env bash
set -euo pipefail
: "${AGENT_PROVIDER_KEY:?Chave Gemini ausente}"
args=(-p "$AGENT_PROMPT")
if [ -n "${MODEL:-}" ]; then args+=(--model "$MODEL"); fi
if [ "${AGENT_MODE:-readonly}" = "edit" ]; then
  args+=(--approval-mode yolo)
else
  args+=(--approval-mode plan)
fi
GEMINI_API_KEY="$AGENT_PROVIDER_KEY" timeout "${AGENT_TIMEOUT:-900}" gemini "${args[@]}"

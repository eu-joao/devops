#!/usr/bin/env bash
set -euo pipefail
PROMPT_FILE="${1:?uso: run-agent.sh <prompt> [arquivo-saida]}"
OUTPUT_FILE="${2:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROVIDER="${AGENT_PROVIDER:-mistral-vibe}"
MODE="${AGENT_MODE:-readonly}"
export AGENT_PROVIDER="$PROVIDER" AGENT_MODE="$MODE"
export AGENT_TIMEOUT="${AGENT_TIMEOUT:-900}" AGENT_MAX_TURNS="${AGENT_MAX_TURNS:-12}"
if [[ "$MODE" != readonly && "$MODE" != edit ]]; then echo "AGENT_MODE deve ser readonly ou edit" >&2; exit 2; fi
# shellcheck disable=SC1091
source "$ROOT/agents/auth/provider-key.sh"
if [ -z "$AGENT_PROVIDER_KEY" ]; then
  echo "::warning::Chave do provedor '$PROVIDER' ausente; execução de IA ignorada."
  if [ -n "${GITHUB_OUTPUT:-}" ]; then echo "ran=false" >> "$GITHUB_OUTPUT"; fi
  exit 0
fi
if [ ! -f "$PROMPT_FILE" ]; then echo "Prompt não encontrado: $PROMPT_FILE" >&2; exit 1; fi
SHARED="$ROOT/prompts/shared/project-rules.md"
if [ ! -f "$SHARED" ]; then echo "Regras compartilhadas não encontradas: $SHARED" >&2; exit 1; fi
AGENT_PROMPT="$(cat "$SHARED"; printf '\n\n'; cat "$PROMPT_FILE")"
if [ -n "${AGENT_CONTEXT:-}" ]; then AGENT_PROMPT+=$'\n\n## Contexto desta execução\n\n'"$AGENT_CONTEXT"; fi
export AGENT_PROMPT
case "$PROVIDER" in
  mistral-vibe) RUNNER="$ROOT/agents/providers/mistral-vibe.sh" ;;
  gemini) RUNNER="$ROOT/agents/providers/gemini.sh" ;;
  *) echo "Provedor não suportado: $PROVIDER" >&2; exit 2 ;;
esac
if [ -n "$OUTPUT_FILE" ]; then bash "$RUNNER" > "$OUTPUT_FILE"; else bash "$RUNNER"; fi
if [ -n "${GITHUB_OUTPUT:-}" ]; then echo "ran=true" >> "$GITHUB_OUTPUT"; fi

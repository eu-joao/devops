#!/usr/bin/env bash
set -euo pipefail
: "${AGENT_PROVIDER_KEY:?Chave Gemini ausente}"
args=(-p "$AGENT_PROMPT")
if [ -n "${MODEL:-}" ]; then args+=(--model "$MODEL"); fi
if [ "${AGENT_MODE:-readonly}" = "edit" ]; then
  args+=(--approval-mode default --allowed-tools "read_file,write_file,replace,run_shell_command")
else
  args+=(--approval-mode plan --allowed-tools "read_file,grep_search,glob,list_directory,read_many_files")
fi
GEMINI_API_KEY="$AGENT_PROVIDER_KEY" timeout "${AGENT_TIMEOUT:-900}" gemini "${args[@]}"

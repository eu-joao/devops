#!/usr/bin/env bash
# Executa um agente de CLI em modo headless com um prompt deste repositório.
#
# Uso: run-agent.sh <arquivo-de-prompt> [arquivo-de-saida]
#
# Variáveis de ambiente:
#   AGENT_CLI       claude | codex | gemini | vibe   (padrão: claude)
#   AGENT_API_KEY   chave de API do provedor do CLI escolhido
#   MODEL           modelo a usar (vazio = padrão do CLI)
#   AGENT_MODE      readonly | edit                  (padrão: readonly)
#   AGENT_CONTEXT   texto extra anexado ao prompt (número do PR, branch base...)
#   AGENT_TIMEOUT   limite em segundos               (padrão: 900)
#
# A resposta final do agente vai para o arquivo de saída (ou para o stdout).
# O agente nunca recebe o token do GitHub: quem comenta, comita e abre PR
# são os workflows e o open-pr.sh.
#
# Atenção: as flags do "claude" são as que este script foi pensado para usar.
# As dos outros CLIs (codex, gemini, vibe) NÃO foram testadas. Confirme na
# documentação da versão instalada antes de depender delas.

set -euo pipefail

PROMPT_FILE="${1:?uso: run-agent.sh <arquivo-de-prompt> [arquivo-de-saida]}"
OUTPUT_FILE="${2:-}"

AGENT_CLI="${AGENT_CLI:-claude}"
AGENT_MODE="${AGENT_MODE:-readonly}"
AGENT_TIMEOUT="${AGENT_TIMEOUT:-900}"
MODEL="${MODEL:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_RULES="$SCRIPT_DIR/../prompts/shared/project-rules.md"

if [ -z "${AGENT_API_KEY:-}" ]; then
  # Acontece em PR vindo de fork, onde o GitHub não repassa secrets.
  echo "::warning::AGENT_API_KEY vazio; o agente não foi executado."
  exit 0
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Prompt não encontrado: $PROMPT_FILE" >&2
  exit 1
fi

PROMPT="$(cat "$SHARED_RULES"; echo; cat "$PROMPT_FILE")"
if [ -n "${AGENT_CONTEXT:-}" ]; then
  PROMPT="$PROMPT"$'\n\n'"## Contexto desta execução"$'\n\n'"$AGENT_CONTEXT"
fi

run_claude() {
  local tools="Read,Grep,Glob,Bash(git diff:*),Bash(git log:*),Bash(git show:*),Bash(git status:*)"
  if [ "$AGENT_MODE" = "edit" ]; then
    tools="$tools,Edit,Write,Bash(npm:*),Bash(npx:*),Bash(mvn:*),Bash(./mvnw:*)"
  fi
  local args=(-p "$PROMPT" --allowedTools "$tools" --max-turns 40)
  if [ -n "$MODEL" ]; then
    args+=(--model "$MODEL")
  fi
  ANTHROPIC_API_KEY="$AGENT_API_KEY" timeout "$AGENT_TIMEOUT" claude "${args[@]}"
}

run_codex() {
  # Não testado. No modo edit o sandbox "workspace-write" costuma bloquear a rede.
  local sandbox="read-only"
  if [ "$AGENT_MODE" = "edit" ]; then
    sandbox="workspace-write"
  fi
  local args=(exec --sandbox "$sandbox")
  if [ -n "$MODEL" ]; then
    args+=(--model "$MODEL")
  fi
  OPENAI_API_KEY="$AGENT_API_KEY" timeout "$AGENT_TIMEOUT" codex "${args[@]}" "$PROMPT"
}

run_gemini() {
  # Não testado. No modo edit, --yolo aprova todas as ações sem perguntar.
  local args=(-p "$PROMPT")
  if [ -n "$MODEL" ]; then
    args+=(--model "$MODEL")
  fi
  if [ "$AGENT_MODE" = "edit" ]; then
    args+=(--yolo)
  fi
  GEMINI_API_KEY="$AGENT_API_KEY" timeout "$AGENT_TIMEOUT" gemini "${args[@]}"
}

run_vibe() {
  # Não testado. Confirme o modo programático e a aprovação automática de
  # ferramentas na documentação do Mistral Vibe.
  local args=(--prompt "$PROMPT")
  MISTRAL_API_KEY="$AGENT_API_KEY" timeout "$AGENT_TIMEOUT" vibe "${args[@]}"
}

case "$AGENT_CLI" in
  claude) runner=run_claude ;;
  codex)  runner=run_codex ;;
  gemini) runner=run_gemini ;;
  vibe)   runner=run_vibe ;;
  *)
    echo "AGENT_CLI desconhecido: $AGENT_CLI (use claude, codex, gemini ou vibe)" >&2
    exit 1
    ;;
esac

if [ -n "$OUTPUT_FILE" ]; then
  "$runner" > "$OUTPUT_FILE"
else
  "$runner"
fi

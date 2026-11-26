#!/usr/bin/env bash
set -euo pipefail
: "${AGENT_PROVIDER_KEY:?Chave Gemini ausente}"
POLICY_FILE="${RUNNER_TEMP:-$HOME}/gemini-devops-policy.toml"
cat > "$POLICY_FILE" <<'TOML'
# Comandos estritamente de leitura liberados no modo de análise.
[[rule]]
toolName = "run_shell_command"
commandPrefix = ["git status", "git diff", "git log", "git show"]
decision = "allow"
priority = 100
modes = ["plan"]

# Comandos de projeto permitidos durante atualização de dependências.
[[rule]]
toolName = "run_shell_command"
commandPrefix = ["git status", "git diff", "git log", "git show", "npm", "npx", "pnpm", "yarn", "mvn", "./mvnw"]
decision = "allow"
priority = 100
modes = ["default", "autoEdit"]
TOML
args=(-p "$AGENT_PROMPT" --policy "$POLICY_FILE")
if [ -n "${MODEL:-}" ]; then args+=(--model "$MODEL"); fi
if [ "${AGENT_MODE:-readonly}" = "edit" ]; then
  args+=(--approval-mode auto_edit)
else
  args+=(--approval-mode plan)
fi
GEMINI_API_KEY="$AGENT_PROVIDER_KEY" timeout "${AGENT_TIMEOUT:-900}" gemini "${args[@]}"

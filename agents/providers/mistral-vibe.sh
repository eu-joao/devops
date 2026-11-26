#!/usr/bin/env bash
set -euo pipefail
: "${AGENT_PROVIDER_KEY:?Chave Mistral Vibe ausente}"
VIBE_HOME="${RUNNER_TEMP:-$HOME}/vibe-home"
mkdir -p "$VIBE_HOME/agents"
if [ "${AGENT_MODE:-readonly}" = "edit" ]; then
  cat > "$VIBE_HOME/agents/devops-ci.toml" <<'TOML'
agent_type = "agent"
display_name = "DevOps CI edit"
description = "Agente de edição limitado ao workspace e comandos de projeto."
safety = "safe"
enabled_tools = ["read_file", "write_file", "edit", "bash"]

[tools.read_file]
permission = "always"

[tools.write_file]
permission = "always"

[tools.edit]
permission = "always"

[tools.bash]
permission = "ask"
allowlist = ["git status", "git diff", "git log", "git show", "npm", "npx", "pnpm", "yarn", "mvn", "./mvnw"]
TOML
else
  cat > "$VIBE_HOME/agents/devops-ci.toml" <<'TOML'
agent_type = "agent"
display_name = "DevOps CI readonly"
description = "Agente de análise sem ferramentas de edição."
safety = "safe"
enabled_tools = ["read_file", "bash"]
disabled_tools = ["edit", "write_file"]

[tools.read_file]
permission = "always"

[tools.bash]
permission = "ask"
TOML
fi
export VIBE_HOME
args=(--agent devops-ci --prompt "$AGENT_PROMPT" --max-turns "${AGENT_MAX_TURNS:-12}" --output text)
if [ -n "${MODEL:-}" ]; then args+=(--model "$MODEL"); fi
MISTRAL_API_KEY="$AGENT_PROVIDER_KEY" timeout "${AGENT_TIMEOUT:-900}" vibe "${args[@]}"

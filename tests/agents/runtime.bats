#!/usr/bin/env bats

setup() {
  ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  RUNTIME="$ROOT/agents/runtime/run-agent.sh"
  PROMPT="$BATS_TEST_TMPDIR/prompt.md"
  OUTPUT="$BATS_TEST_TMPDIR/output.txt"
  BIN="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$BIN"
  printf '# Prompt de teste\n' > "$PROMPT"
}

@test "ignora execução quando a chave do Mistral está ausente" {
  run env -u MISTRAL_VIBE_CODE_KEY -u GEMINI_API_KEY AGENT_PROVIDER=mistral-vibe GITHUB_OUTPUT="$OUTPUT" bash "$RUNTIME" "$PROMPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"execução de IA ignorada"* ]]
  grep -q 'ran=false' "$OUTPUT"
}

@test "ignora execução quando a chave do Gemini está ausente" {
  run env -u MISTRAL_VIBE_CODE_KEY -u GEMINI_API_KEY AGENT_PROVIDER=gemini GITHUB_OUTPUT="$OUTPUT" bash "$RUNTIME" "$PROMPT"
  [ "$status" -eq 0 ]
  grep -q 'ran=false' "$OUTPUT"
}

@test "rejeita provedor desconhecido" {
  run env AGENT_PROVIDER=desconhecido bash "$RUNTIME" "$PROMPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"AGENT_PROVIDER inválido"* ]]
}

@test "rejeita modo de execução inválido" {
  run env AGENT_PROVIDER=mistral-vibe AGENT_MODE=unsafe bash "$RUNTIME" "$PROMPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"AGENT_MODE deve ser readonly ou edit"* ]]
}

@test "não exporta a chave intermediária para processos filhos" {
  run env AGENT_PROVIDER=mistral-vibe MISTRAL_VIBE_CODE_KEY=test-key bash -c 'source "$1"; env | grep "^AGENT_PROVIDER_KEY="' _ "$ROOT/agents/auth/provider-key.sh"
  [ "$status" -ne 0 ]
}

@test "adaptador Mistral executa em modo somente leitura sem autoaprovação" {
  cat > "$BIN/vibe" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$MISTRAL_API_KEY" "$@" > "$CAPTURE"
SH
  chmod +x "$BIN/vibe"
  run env PATH="$BIN:$PATH" AGENT_PROVIDER_KEY=test-key AGENT_PROMPT=prompt CAPTURE="$OUTPUT" RUNNER_TEMP="$BATS_TEST_TMPDIR" AGENT_MODE=readonly bash -c 'source "$1"' _ "$ROOT/agents/providers/mistral-vibe.sh"
  [ "$status" -eq 0 ]
  grep -q '^test-key$' "$OUTPUT"
  grep -q '^--prompt$' "$OUTPUT"
  ! grep -q '^--auto-approve$' "$OUTPUT"
  grep -q 'devops-ci.toml' "$BATS_TEST_TMPDIR/vibe-home/agents/devops-ci.toml"
}

@test "adaptador Mistral habilita edição sem liberar shell irrestrito" {
  cat > "$BIN/vibe" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$CAPTURE"
SH
  chmod +x "$BIN/vibe"
  run env PATH="$BIN:$PATH" AGENT_PROVIDER_KEY=test-key AGENT_PROMPT=prompt CAPTURE="$OUTPUT" RUNNER_TEMP="$BATS_TEST_TMPDIR" AGENT_MODE=edit bash -c 'source "$1"' _ "$ROOT/agents/providers/mistral-vibe.sh"
  [ "$status" -eq 0 ]
  grep -q '^--auto-approve$' "$OUTPUT"
  grep -q 'allowlist = \["git status", "git diff", "git log", "git show", "npm"' "$BATS_TEST_TMPDIR/vibe-home/agents/devops-ci.toml"
}

@test "adaptador Gemini usa Plan Mode e política de comandos de leitura" {
  cat > "$BIN/gemini" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$GEMINI_API_KEY" "$@" > "$CAPTURE"
SH
  chmod +x "$BIN/gemini"
  run env PATH="$BIN:$PATH" AGENT_PROVIDER_KEY=test-key AGENT_PROMPT=prompt CAPTURE="$OUTPUT" RUNNER_TEMP="$BATS_TEST_TMPDIR" AGENT_MODE=readonly bash -c 'source "$1"' _ "$ROOT/agents/providers/gemini.sh"
  [ "$status" -eq 0 ]
  grep -q '^test-key$' "$OUTPUT"
  grep -q '^--approval-mode$' "$OUTPUT"
  grep -q '^plan$' "$OUTPUT"
  grep -q 'modes = \["plan"\]' "$BATS_TEST_TMPDIR/gemini-devops-policy.toml"
}

@test "adaptador Gemini usa auto-edit com comandos de projeto restritos" {
  cat > "$BIN/gemini" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$CAPTURE"
SH
  chmod +x "$BIN/gemini"
  run env PATH="$BIN:$PATH" AGENT_PROVIDER_KEY=test-key AGENT_PROMPT=prompt CAPTURE="$OUTPUT" RUNNER_TEMP="$BATS_TEST_TMPDIR" AGENT_MODE=edit bash -c 'source "$1"' _ "$ROOT/agents/providers/gemini.sh"
  [ "$status" -eq 0 ]
  grep -q '^auto_edit$' "$OUTPUT"
  grep -q 'commandPrefix = \["git status", "git diff", "git log", "git show", "npm"' "$BATS_TEST_TMPDIR/gemini-devops-policy.toml"
}

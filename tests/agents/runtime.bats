#!/usr/bin/env bats

setup() {
  ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  RUNTIME="$ROOT/agents/runtime/run-agent.sh"
  PROMPT="$BATS_TEST_TMPDIR/prompt.md"
  OUTPUT="$BATS_TEST_TMPDIR/output.txt"
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

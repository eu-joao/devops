# Contribuindo

## Branches

Use `<número-da-issue>-<descrição-curta>`, em minúsculas e separado por hífen.

## Commits

Use `tipo: descrição`, em português e no imperativo. Tipos: `feat`, `fix`, `docs`, `ci`, `chore`.

## Pull Requests

Descreva o que mudou, a issue relacionada e dependências externas. Não faça merge sem revisão humana.

## Validação local

- `shellcheck` nos scripts shell.
- `bats tests/` para os testes de scripts.
- `actionlint` nos workflows.
- `zizmor .github/workflows` para análise de segurança.

Os testes automatizados não devem chamar provedores de IA reais.

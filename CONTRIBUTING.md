# Contribuindo

## Organização

- Workflows reutilizáveis ficam em `.github/workflows/`.
- Skills compartilhadas ficam em `agents/skills/`.
- Scripts e prompts ficam em `scripts/` e `prompts/`.
- O template de issue fica em `.github/ISSUE_TEMPLATE/`; o de pull request, em `.github/pull_request_template.md`.
- Projetos consumidores devem manter apenas os workflows chamadores, sem copiar a implementação central.
- A CI determinística não depende de secrets de IA ou de um GitHub App.
- Agentes não recebem tokens do GitHub. Publicação e comentários usam um GitHub App em etapas separadas.

## Branches

Use `<número-da-issue>-<descrição-curta>`, em minúsculas e separado por hífen.

## Commits

Use `tipo: descrição`, em português e no imperativo. Tipos: `feat`, `fix`, `docs`, `ci`, `chore`.

## Pull requests

Descreva o que mudou e informe a issue relacionada. Use o template do repositório. Não faça merge sem revisão humana.

Ao alterar um workflow reutilizável, revise seus inputs, descrições, permissões e comportamento nos repositórios consumidores. Mantenha as descrições dos inputs e fixe actions externas por SHA completo.

## Validação local

- `shellcheck -x` nos scripts shell.
- `bats tests/agents` para os testes dos scripts.
- `actionlint` nos workflows.
- `zizmor .github/workflows` para análise de segurança.

Os testes não devem chamar provedores de IA reais nem consumir cotas. Prefira comandos simulados e credenciais fictícias.

## CI

O workflow `.github/workflows/ci-devops.yml` valida este repositório. Nos projetos consumidores, use os workflows reutilizáveis específicos de cada stack.

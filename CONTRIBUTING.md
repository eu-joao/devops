# Contribuindo

## Organização

- Workflows reutilizáveis ficam em `.github/workflows/`.
- Skills compartilhadas ficam em `.agents/skills/`.
- Scripts e prompts ficam em `scripts/` e `prompts/`.
- O template de issue fica em `.github/ISSUE_TEMPLATE/`; o de pull request, em `.github/pull_request_template.md`.
- Projetos consumidores devem manter apenas os workflows chamadores, sem copiar a implementação central.
- A CI determinística não depende de secrets de IA ou de um GitHub App.
- Agentes não recebem tokens do GitHub. Publicação e comentários usam um GitHub App em etapas separadas.

## Estratégia de branches

Adotamos Trunk-Based Development:

- `main` é a única branch permanente e deve permanecer funcional.
- Crie branches curtas e descritivas para cada alteração, sem exigir número de issue.
- Use prefixos como `feat/`, `fix/`, `docs/`, `ci/`, `chore/` e `test/`.
- Abra PRs diretamente para `main`, aguarde os checks e a revisão humana antes do merge.
- Faça merge assim que a alteração estiver pronta e exclua a branch após o merge.
- Evite branches de integração ou desenvolvimento de longa duração.
- Use tags para marcar versões e releases.

## Commits

Use `tipo: descrição`, em português e no imperativo. Tipos: `feat`, `fix`, `docs`, `ci`, `chore`.

## Pull requests

Direcione os PRs para `main`. Descreva o que mudou e informe a issue relacionada quando existir. Use o template do repositório. Não faça merge sem revisão humana.

Ao alterar um workflow reutilizável, revise seus inputs, descrições, permissões e comportamento nos repositórios consumidores. Mantenha as descrições dos inputs e fixe actions externas por SHA completo.

## Validação local

- `shellcheck -x` nos scripts shell.
- `bats tests/agents` para os testes dos scripts.
- `actionlint` nos workflows.
- `zizmor .github/workflows` para análise de segurança.

Os testes não devem chamar provedores de IA reais nem consumir cotas. Prefira comandos simulados e credenciais fictícias.

## CI

O workflow `.github/workflows/ci-devops.yml` valida este repositório. Nos projetos consumidores, use os workflows reutilizáveis específicos de cada stack.

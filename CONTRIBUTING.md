# Contribuindo

## Sumário

- [Branches](#branches)
- [Commits](#commits)
- [Pull Requests](#pull-requests)

## Branches

Use o formato `<número-da-issue>-<descrição-curta>`, em minúsculas e separado por hífen. Exemplo: `12-agente-review-pr`.

## Commits

Use o formato `tipo: descrição`, em português e no imperativo. Os tipos são `feat`, `fix`, `docs`, `ci` e `chore`. Exemplo: `feat: adiciona workflow de review de PR`.

## Pull Requests

O que a descrição de um PR precisa ter:

- **O que mudou?** Uma a três frases, direto ao ponto.
- **Issue:** link ou `#número`.
- **Outras dependências:** `N/A` ou a lista.

Antes de abrir o PR, teste a mudança em um projeto de verdade: aponte o arquivo de chamada para a sua branch usando `@nome-da-branch` e `devops_ref: nome-da-branch`.

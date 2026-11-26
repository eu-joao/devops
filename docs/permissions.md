# Permissões

## Princípio

O agente recebe acesso ao workspace e à chave do provedor selecionado. Nunca recebe token GitHub. O token do GitHub App só é criado em etapa posterior, fora do processo do agente.

| Workflow | Token de checkout | GitHub App | Capacidade |
|---|---|---|---|
| `ci-node`, `ci-spring` | contents: read | nenhum | build e testes |
| `agent-review-pr` | contents: read | pull-requests: write | comentar review |
| `agent-triage-issue` | contents: read | issues: write | comentar triagem |
| `agent-update-deps` | contents: read | contents: write, pull-requests: write | abrir PR |

## Regras

- Usar `pull_request`, nunca `pull_request_target`, para executar código de PR.
- Checkout com `persist-credentials: false`.
- Secrets de provedor e GitHub App não devem ser expostos a forks.
- O GitHub App token é gerado somente após o agente concluir.
- Não conceder `contents: write` ao `GITHUB_TOKEN` do job do agente.
- Conteúdo de issues e PRs é dado não confiável, nunca instrução de sistema.

## Execução sem agente

Workflows de CI não declaram nem recebem secrets de IA. Callers de agentes são arquivos independentes e opcionais.

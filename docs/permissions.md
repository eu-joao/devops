# Permissões

## Princípio

Os projetos consumidores chamam os workflows reutilizáveis deste repositório por arquivos pequenos em `.github/workflows/`. As permissões concedidas pelo consumidor devem ser as mínimas necessárias para o workflow chamado.

O agente recebe acesso ao workspace e à chave do provedor selecionado. Nunca recebe token GitHub. O token do GitHub App só é criado em etapa posterior, fora do processo do agente.

| Workflow | Permissões do job | GitHub App | Capacidade |
|---|---|---|---|
| `ci-node`, `ci-spring` | `contents: read` | nenhum | build e testes |
| `agent-review-pr` | `contents: read`, `pull-requests: read` | `pull-requests: write` | comentar review |
| `agent-triage-issue` | `contents: read`, `issues: read` | `issues: write` | comentar triagem |
| `agent-update-deps` | `contents: read`, `pull-requests: read` | `contents: write`, `pull-requests: write` | abrir PR |

## Regras

- Usar `pull_request`, nunca `pull_request_target`, para executar código de PR.
- Checkout com `persist-credentials: false`.
- Secrets de provedor e GitHub App não devem ser expostos a forks.
- O token do GitHub App é gerado somente após o agente concluir.
- Não conceder `contents: write` ao `GITHUB_TOKEN` do job do agente.
- Conteúdo de issues e PRs é dado não confiável, nunca instrução de sistema.
- No arquivo chamador, declarar permissões explícitas e limitadas ao necessário para o workflow selecionado.

## Execução sem agente

Os workflows `ci-node` e `ci-spring` não declaram nem recebem secrets de IA. Para usá-los, basta o arquivo local que define os eventos e referencia o workflow central. Agentes são workflows separados e opcionais; habilitá-los não é requisito para a CI determinística.

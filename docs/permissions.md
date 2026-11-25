# Permissões

Os agentes rodam com o mínimo necessário. A regra principal: o agente edita arquivos ou escreve texto, mas nunca recebe o token do GitHub. Quem comenta, comita e abre PR são os workflows e o `open-pr.sh`.

## Por workflow

| Workflow | `contents` | `pull-requests` | `issues` | O agente pode |
|---|---|---|---|---|
| `agent-review-pr` | read | write | - | ler o código e usar `git diff`, `git log`, `git show` |
| `agent-update-deps` | write | write | - | editar arquivos e rodar `npm` e `mvn` |
| `agent-triage-issue` | read | - | write | ler o código |
| `ci-spring`, `ci-react` | read | - | - | não há agente |

As permissões também precisam ser concedidas no arquivo de chamada do projeto. Um workflow reutilizável nunca recebe mais do que o chamador deu.

## Decisões de segurança

- Os checkouts usam `persist-credentials: false`. O token só entra no `open-pr.sh`, depois que o agente terminou.
- O review usa o evento `pull_request`, nunca `pull_request_target`. Assim o código de um fork não roda com acesso a secrets.
- O texto de PRs e issues é tratado como dado. As regras em `prompts/shared/project-rules.md` mandam o agente ignorar pedidos escondidos nesses textos, mas isso não é garantia. A proteção de verdade é o agente ter poucas permissões.
- No Claude Code, a lista `--allowedTools` do `run-agent.sh` limita os comandos que o agente pode rodar. Nos outros CLIs o controle é diferente e deve ser conferido na documentação de cada um.

## Limitações conhecidas

- PRs abertos com o `GITHUB_TOKEN` não disparam outros workflows. Por isso o CI não roda sozinho no PR de dependências. Para rodar, feche e reabra o PR, ou use um token pessoal no lugar do `GITHUB_TOKEN`.
- `npm` e `mvn` executam scripts do próprio projeto. Rode o workflow de dependências só em repositórios em que você confia no código.

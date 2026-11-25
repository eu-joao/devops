# Secrets

Os workflows de agente usam um único secret, `AGENT_API_KEY`. O script `run-agent.sh` entrega essa chave ao CLI pela variável que ele espera.

| `agent_cli` | Variável usada pelo CLI | Onde gerar a chave |
|---|---|---|
| `claude` | `ANTHROPIC_API_KEY` | Console da Anthropic |
| `codex` | `OPENAI_API_KEY` | Painel da OpenAI |
| `gemini` | `GEMINI_API_KEY` | Google AI Studio |
| `vibe` | `MISTRAL_API_KEY` | Mistral Studio |

## Onde criar

Em cada projeto: **Settings > Secrets and variables > Actions > New repository secret**. O nome precisa ser exatamente `AGENT_API_KEY`.

## Cuidados

- Nunca coloque a chave no código, nos prompts ou em arquivos `.env` versionados.
- Defina um limite de gasto no painel do provedor. Um agente em loop pode consumir créditos rápido.
- PRs vindos de forks não recebem secrets. Nesse caso o agente é pulado, com um aviso no log.
- Se o repositório `devops` for privado, o segundo checkout dos workflows não consegue lê-lo com o token padrão do Actions. O caminho mais simples é manter `devops` público, já que ele não guarda segredos. A alternativa é criar um token (PAT) ou uma deploy key com leitura só nesse repositório e usá-lo nesse checkout.

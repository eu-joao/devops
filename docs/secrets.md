# Secrets

## Chaves dos provedores

Configure somente o secret do provedor escolhido em **Settings > Secrets and variables > Actions**.

| Provider | Secret no repositório consumidor | Variável usada pelo CLI |
|---|---|---|
| Mistral Vibe | `MISTRAL_VIBE_CODE_KEY` | `MISTRAL_API_KEY` |
| Gemini CLI | `GEMINI_API_KEY` | `GEMINI_API_KEY` |

Não existe mais `AGENT_API_KEY`. Sem a chave correspondente, a etapa de IA é ignorada e o CI continua normalmente. Se a chave estiver configurada e for inválida, a execução deve falhar explicitamente.

Use a chave específica do Vibe Code, não presuma que uma chave da API tradicional do Mistral Studio tenha a mesma quota ou condições. Para Gemini, verifique os termos de tratamento de dados do nível gratuito antes de enviar código privado.

## GitHub App

Secrets necessários:
- `GH_APP_ID`: ID numérico do aplicativo.
- `GH_APP_PRIVATE_KEY`: chave privada PEM do aplicativo.

Permissões mínimas:
- Contents: read/write (workflow de atualização de dependências).
- Pull requests: read/write (criar PR e comentar em PR).
- Issues: read/write (comentar em issues).

Instale o App apenas nos repositórios que usarão essas automações. O token de instalação é criado depois da execução do agente e nunca é exposto ao processo do modelo. O token tem validade curta.

O token de instalação permite que PRs criados pelo workflow iniciem workflows subsequentes, ao contrário da limitação usual do `GITHUB_TOKEN`.

## Cuidados

- Nunca versionar secrets ou arquivos de credenciais.
- Não disponibilizar secrets a workflows disparados por forks.
- Não imprimir valores de secrets nos logs.
- Não passar tokens do GitHub como contexto ou variável ao agente.

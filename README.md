# devops

Workflows reutilizáveis de CI e automações assistidas por IA para projetos acadêmicos e pessoais.

## Princípios

- CI funciona independentemente de qualquer agente ou chave de IA.
- Mistral Vibe é o provedor preferencial; Gemini CLI é a alternativa gratuita.
- Provedor, autenticação e modo de execução são configurações separadas.
- Agentes não recebem tokens do GitHub. Ações de publicação usam um GitHub App.
- Testes automatizados não chamam modelos reais nem consomem cotas.
- CD será considerado somente depois da estabilização do CI.

## Estrutura

```text
.github/workflows/
  ci-node.yml              # CI compartilhado por Vue, React e outros projetos Node
  ci-spring.yml            # CI para Spring Boot/Maven
  ci-devops.yml            # testes e análise deste repositório
  agent-review-pr.yml
  agent-triage-issue.yml
  agent-update-deps.yml
agents/
  runtime/run-agent.sh
  providers/{mistral-vibe,gemini}.sh
  auth/provider-key.sh
actions/                    # reservado para etapas realmente reutilizáveis
docs/
prompts/
scripts/
templates/callers/
tests/
```

## Começar sem agentes

Copie `templates/callers/ci.yml` para o projeto, ajuste os diretórios e troque `SEU_USUARIO`. Não é necessário criar secrets.

## Habilitar agentes

1. Escolha `mistral-vibe` ou `gemini` no input `agent_provider`.
2. Configure somente o secret correspondente: `MISTRAL_VIBE_CODE_KEY` ou `GEMINI_API_KEY`.
3. Para comentários e PRs automatizados, configure também `GH_APP_ID` e `GH_APP_PRIVATE_KEY` de um GitHub App instalado no repositório.
4. Copie apenas os callers de agente que pretende usar.

Sem a chave do provedor, a etapa de agente é ignorada com aviso; o CI convencional continua funcionando. Uma chave presente mas inválida causa falha explícita.

Consulte [adicionando um projeto](docs/adding-a-project.md), [arquitetura](docs/architecture.md), [secrets](docs/secrets.md) e [permissões](docs/permissions.md).

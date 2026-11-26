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
docs/
prompts/
scripts/
templates/callers/
tests/
```

## Começar sem agentes

Os templates de CI são **Reusable Workflows** hospedados neste repositório. Não copie a implementação dos workflows para os projetos consumidores: crie apenas um pequeno workflow chamador em `.github/workflows/`, que referencia o workflow central com `uses`.

Exemplo para um projeto Node/Vue:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  ci:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-node.yml@main
    with:
      node_version: "22"
      working_directory: "."
      package_manager: npm
```

Para Spring Boot/Maven, use `ci-spring.yml` e informe `java_version` e `working_directory`. Projetos com backend e frontend podem chamar os dois workflows em jobs separados. Os exemplos completos estão em [templates/callers/](templates/callers/).

O arquivo chamador continua necessário porque cada repositório define seus próprios eventos, branches e parâmetros. A implementação do CI, porém, permanece centralizada aqui. Não é necessário criar secrets para usar CI.

## Habilitar agentes

1. Escolha `mistral-vibe` ou `gemini` no input `agent_provider`.
2. Configure somente o secret correspondente: `MISTRAL_VIBE_CODE_KEY` ou `GEMINI_API_KEY`.
3. Para comentários e PRs automatizados, configure também `GH_APP_ID` e `GH_APP_PRIVATE_KEY` de um GitHub App instalado no repositório.
4. Copie apenas os callers de agente que pretende usar.

Sem a chave do provedor, a etapa de agente é ignorada com aviso; o CI convencional continua funcionando. Uma chave presente mas inválida causa falha explícita.

Consulte [adicionando um projeto](docs/adding-a-project.md), [arquitetura](docs/architecture.md), [secrets](docs/secrets.md) e [permissões](docs/permissions.md).

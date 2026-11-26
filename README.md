# devops

Workflows reutilizáveis de CI e automações assistidas por IA para projetos acadêmicos e pessoais.

## Princípios

- A implementação da CI fica centralizada neste repositório; os consumidores mantêm apenas arquivos pequenos que selecionam os workflows e definem seus eventos.
- CI determinística funciona independentemente de agentes ou chaves de IA.
- Mistral Vibe é o provedor preferencial; Gemini CLI é a alternativa.
- Provedor, autenticação e modo de execução são configurações separadas.
- Agentes não recebem tokens do GitHub. Ações de publicação usam um GitHub App.
- Testes automatizados não chamam modelos reais nem consomem cotas.
- CD será considerado somente depois da estabilização do CI.

## Estrutura

```text
.github/workflows/
  ci-node.yml              # CI compartilhada por Vue, React e outros projetos Node
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
templates/                 # templates de container
tests/
```

## Usar a CI em outro repositório

A implementação dos workflows fica neste repositório e é consumida por meio de [Reusable Workflows do GitHub Actions](https://docs.github.com/actions/sharing-automations/reusing-workflows). No projeto consumidor, mantenha somente um arquivo em `.github/workflows/` que define os eventos e aponta para o workflow central com `uses`. Não copie scripts, etapas ou arquivos de implementação.

Para Vue, React ou outros projetos Node, por exemplo:

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

Para Spring Boot/Maven, aponte para `ci-spring.yml` e, se necessário, informe `java_version` e `working_directory`. Um repositório com frontend e backend pode declarar um job para cada workflow.

Os arquivos locais definem quando a CI roda e quais parâmetros são usados; instalação de ferramentas, execução de lint, testes e build permanecem gerenciados pelo repositório central. Os inputs disponíveis estão documentados nos próprios workflows.

Durante o desenvolvimento, `@main` acompanha as alterações mais recentes. Para execuções reproduzíveis, prefira uma tag estável ou SHA completo. Não são necessários secrets para usar os workflows de CI.

Consulte o [guia de integração](docs/adding-a-project.md).

## Habilitar agentes (opcional)

Os workflows de agentes também são reutilizáveis. O repositório consumidor declara os eventos que devem acioná-los e referencia o workflow correspondente; não precisa copiar sua implementação.

1. Escolha `mistral-vibe` ou `gemini` no input `agent_provider`.
2. Configure somente o secret correspondente: `MISTRAL_VIBE_CODE_KEY` ou `GEMINI_API_KEY`.
3. Para comentários e PRs automatizados, configure também `GH_APP_ID` e `GH_APP_PRIVATE_KEY` de um GitHub App instalado no repositório.
4. Ao chamar os workflows de agentes, informe `devops_repository: eu-joao/devops` e a referência desejada em `devops_ref`. Encaminhe os secrets necessários ao workflow reutilizável.

Sem a chave do provedor, a execução do agente é ignorada com aviso; a CI determinística continua funcionando. Uma chave presente mas inválida causa falha explícita.

Consulte [arquitetura](docs/architecture.md), [secrets](docs/secrets.md) e [permissões](docs/permissions.md).

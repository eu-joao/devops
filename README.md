# devops

Workflows reutilizáveis de CI, instruções para agentes e skills compartilhadas para projetos acadêmicos e pessoais.

## Princípios

- A implementação da CI fica centralizada neste repositório; consumidores mantêm apenas arquivos chamadores pequenos.
- Cada stack possui um workflow adequado. Projetos só chamam as verificações que realmente usam.
- CI determinística funciona independentemente de agentes ou chaves de IA.
- Provedor, autenticação e modo de execução são configurações separadas.
- Agentes não recebem tokens do GitHub. Ações de publicação usam um GitHub App.
- Testes automatizados não chamam modelos reais nem consomem cotas.
- CD será considerado somente depois da estabilização do CI.

## Estrutura

```text
.github/
  ISSUE_TEMPLATE/
  workflows/
    ci-node.yml
    ci-mobile-expo.yml
    ci-nextjs.yml
    ci-spring.yml
    ci-pr-title.yml
    ci-commitlint.yml
    ci-markdownlint.yml
    ci-devops.yml
    agent-review-pr.yml
    agent-triage-issue.yml
    agent-update-deps.yml
agents/
  runtime/
  providers/
  auth/
.agents/
  skills/
docs/
prompts/
scripts/
templates/
tests/
AGENTS.md
```

## Usar a CI em outro repositório

A implementação dos workflows fica neste repositório e é consumida por meio de [Reusable Workflows do GitHub Actions](https://docs.github.com/actions/sharing-automations/reusing-workflows). No projeto consumidor, mantenha somente um arquivo em `.github/workflows/` que define os eventos e aponta para o workflow central com `uses`.

Exemplo para Node:

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
      package_manager: npm
```

Para Expo/React Native, Next.js ou Spring Boot, use respectivamente `ci-mobile-expo.yml`, `ci-nextjs.yml` ou `ci-spring.yml`. Workflows para título de PR, Commitlint e Markdownlint são opcionais e independentes.

Os workflows usam a raiz do repositório como diretório de trabalho padrão. Em monorepos, informe `working_directory` no bloco `with` do workflow consumidor para apontar ao diretório da aplicação.

Os padrões compartilhados são **Node.js 24** e **Java Temurin 17**, definidos em `.github/workflows/runtime-versions.yml`. Os workflows de Node, Expo, Next.js, Commitlint, Spring e atualização de dependências herdam essas versões. Informe `node_version` ou `java_version` somente quando o projeto precisar de uma versão diferente.

As Actions externas são fixadas por SHA imutável. Quando uma Action for atualizada, mantenha o mesmo SHA e comentário de versão em todas as ocorrências correspondentes; a lista e a política ficam documentadas em [versões e atualizações](docs/versions.md).

Consulte o [guia de integração](docs/adding-a-project.md) para exemplos e inputs.

Durante o desenvolvimento, `@main` acompanha as alterações mais recentes. Para execuções reproduzíveis, prefira uma tag estável ou SHA completo. Não são necessários secrets para usar os workflows determinísticos.

## Habilitar agentes (opcional)

Os workflows de agentes também são reutilizáveis. O repositório consumidor declara os eventos que devem acioná-los e referencia o workflow correspondente; não precisa copiar sua implementação.

1. Escolha `mistral-vibe` ou `gemini` no input `agent_provider`.
2. Configure somente o secret correspondente: `MISTRAL_VIBE_CODE_KEY` ou `GEMINI_API_KEY`.
3. Para comentários e PRs automatizados, configure também `GH_APP_ID` e `GH_APP_PRIVATE_KEY` de um GitHub App instalado no repositório.
4. Informe `devops_repository: eu-joao/devops` e a referência desejada em `devops_ref`.

Sem a chave do provedor, a execução do agente é ignorada com aviso; a CI determinística continua funcionando. Uma chave presente mas inválida causa falha explícita.

Consulte [arquitetura](docs/architecture.md), [secrets](docs/secrets.md) e [permissões](docs/permissions.md).

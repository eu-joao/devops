# Adicionando um projeto

## 1. Escolha os workflows

A implementação da CI é mantida em `eu-joao/devops`. No projeto consumidor, crie somente arquivos pequenos em `.github/workflows/` que definem os eventos e chamam os workflows centrais com `uses`.

Não copie etapas, scripts ou arquivos de implementação para o projeto consumidor.

### Vue, React ou outro projeto Node

Use `ci-node.yml` para verificações genéricas de Node:

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

### Mobile com Expo / React Native

Use `ci-mobile-expo.yml`. Ele instala dependências e pode executar Prettier, lint, TypeScript, Expo Doctor e exportação de bundles para iOS, Android e Web.

```yaml
jobs:
  mobile:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-mobile-expo.yml@main
    with:
      package_manager: npm
```

As etapas podem ser desligadas pelos inputs `run_prettier`, `run_lint`, `run_typecheck`, `run_expo_doctor` e `run_export` quando o projeto não usar a verificação correspondente.

### Web com Next.js

Use `ci-nextjs.yml`:

```yaml
jobs:
  web:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-nextjs.yml@main
    with:
      package_manager: npm
```

O workflow executa lint, Next.js typegen, TypeScript, build e, quando houver script `test`, testes. Os inputs `run_lint`, `run_typecheck`, `run_build` e `run_tests` controlam essas etapas.

### Spring Boot / Maven

Use `ci-spring.yml`:

```yaml
jobs:
  backend:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-spring.yml@main
    with:
      working_directory: "backend"
```

### Projetos com mais de uma stack ou monorepos

Declare um job para cada workflow aplicável. Cada job pode apontar para seu próprio diretório de trabalho. Informe `working_directory` somente quando a aplicação não estiver na raiz do repositório.

Por exemplo, para um frontend dentro de `frontend/`:

```yaml
jobs:
  web:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-nextjs.yml@main
    with:
      working_directory: frontend
```

### Título de PR e mensagens de commit

Essas verificações são workflows separados para que cada projeto escolha se deseja adotá-las:

```yaml
jobs:
  pr-title:
    permissions:
      pull-requests: read
    uses: eu-joao/devops/.github/workflows/ci-pr-title.yml@main

  commitlint:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-commitlint.yml@main
```

O workflow de Commitlint pressupõe que o projeto já tenha `@commitlint/cli`, uma configuração e lockfile compatíveis com o gerenciador escolhido.

## 2. Configuração de pacotes

Os workflows Node especializados aceitam `npm`, `pnpm` ou `yarn`, usam o lockfile do diretório indicado e instalam dependências em modo imutável.

Todos os workflows compartilham Node.js 24 e Java Temurin 17 como padrões. Para um projeto que precise de outra versão, informe `node_version` ou `java_version` no bloco `with` do workflow consumidor. Não é necessário alterar o workflow central.

## 3. Templates de contribuição

O template de issue fica em `.github/ISSUE_TEMPLATE/` e o de pull request em `.github/pull_request_template.md`.

## 4. Habilite agentes (opcional)

Os workflows de agentes também são reutilizáveis. No repositório consumidor, crie um arquivo pequeno para o evento desejado e aponte para um dos workflows centrais:

- `agent-review-pr.yml`: revisão de pull requests.
- `agent-triage-issue.yml`: triagem de issues.
- `agent-update-deps.yml`: atualização de dependências.

Informe o input obrigatório `devops_repository: eu-joao/devops`. Use `devops_ref` para selecionar a branch, tag ou SHA do repositório compartilhado. Configure `agent_provider` e encaminhe os secrets necessários. Consulte [secrets.md](secrets.md) e [permissions.md](permissions.md).

A CI determinística não depende de secrets de IA nem de GitHub App.

## 5. Fixe uma versão

Durante o desenvolvimento, `@main` acompanha as alterações mais recentes. Os padrões de runtime são resolvidos pelo workflow compartilhado `runtime-versions.yml`, chamado por caminho relativo. Assim, ele sempre acompanha exatamente a mesma referência (branch, tag ou SHA) do workflow consumidor. Depois de validar uma versão estável, prefira uma tag ou SHA completo para execuções reproduzíveis.

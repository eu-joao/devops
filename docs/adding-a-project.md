# Adicionando um projeto

## 1. Escolha o workflow

A implementação da CI é mantida em `eu-joao/devops`. No projeto consumidor, crie apenas um arquivo de configuração em `.github/workflows/` que define os eventos e referencia o workflow reutilizável adequado com `uses`.

Não copie workflows de implementação, scripts, etapas de instalação ou templates deste repositório.

### Vue, React ou outro projeto Node

Crie, por exemplo, `.github/workflows/ci.yml`:

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

O workflow Node também aceita os inputs `run_lint`, `run_tests` e `run_build`, que permitem habilitar ou desabilitar essas etapas. Cada etapa é executada somente quando habilitada e quando o script correspondente existe no `package.json`.

### Spring Boot/Maven

Aponte o job para `ci-spring.yml`:

```yaml
jobs:
  ci:
    permissions:
      contents: read
    uses: eu-joao/devops/.github/workflows/ci-spring.yml@main
    with:
      java_version: "21"
      working_directory: "."
```

Se frontend e backend estiverem em diretórios independentes, declare um job para cada workflow e informe o respectivo `working_directory`.

Os eventos e branches são definidos no arquivo local. O workflow central executa instalação, lint, testes e build, conforme a stack e os inputs. Os inputs e seus valores padrão estão descritos nos próprios arquivos de workflow.

Não é necessário configurar secrets, GitHub App ou agente para usar a CI determinística.

## 2. (Opcional) Habilite agentes

Os workflows de agentes também são reutilizáveis. No repositório consumidor, crie um arquivo pequeno em `.github/workflows/` para o evento desejado e aponte para um dos workflows centrais:

- `agent-review-pr.yml`: revisão de pull requests.
- `agent-triage-issue.yml`: triagem de issues.
- `agent-update-deps.yml`: atualização de dependências.

Informe o input obrigatório `devops_repository: eu-joao/devops`. Use `devops_ref` para selecionar a branch, tag ou SHA do repositório compartilhado. Configure o `agent_provider` como `mistral-vibe` ou `gemini` e encaminhe os secrets necessários ao workflow reutilizável. Consulte [secrets.md](secrets.md) e [permissions.md](permissions.md).

Sem a chave do provedor selecionado, o agente é ignorado com aviso. A CI determinística não depende dessas credenciais.

## 3. (Opcional) Configure o GitHub App

Para comentários e PRs automáticos, crie um GitHub App, instale-o no projeto e configure `GH_APP_ID` e `GH_APP_PRIVATE_KEY`. Conceda somente as permissões necessárias à automação habilitada. Consulte [secrets.md](secrets.md).

## 4. Valide a integração

Abra um pull request ou faça um push correspondente aos eventos definidos no arquivo local e confirme que o workflow central foi executado. Habilite e valide agentes separadamente. Não execute automações de edição em repositórios cujo código ou scripts não sejam confiáveis.

## 5. Fixe uma versão

Durante o desenvolvimento, `@main` acompanha as alterações mais recentes deste repositório. Depois de validar uma versão estável, prefira uma tag e atualize a referência no arquivo local. Para máxima previsibilidade, use um SHA completo.

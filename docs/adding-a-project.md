# Adicionando um projeto

## 1. Configure o CI

Os workflows de CI são reutilizáveis e ficam centralizados neste repositório. No projeto consumidor, crie um arquivo chamador em `.github/workflows/ci.yml` que referencia o workflow adequado com `uses`. Não copie os arquivos de implementação de CI.

Para Vue, React ou outros projetos Node:

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

Para Spring Boot/Maven, troque o workflow e ajuste os parâmetros:

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

Se o projeto tiver backend e frontend independentes, declare dois jobs, cada um chamando o workflow correspondente e informando seu próprio `working_directory`. Os exemplos completos estão em [templates/callers/](../templates/callers/).

O arquivo chamador é necessário para definir os eventos e parâmetros específicos do projeto. A implementação dos jobs, instalação de ferramentas, testes e build permanece no repositório central.

Não é necessário configurar secrets, GitHub App ou agente para usar CI.

## 2. (Opcional) Habilite agentes

Crie arquivos chamadores para as automações que deseja habilitar, usando os exemplos em `templates/callers/`. Eles também chamam workflows reutilizáveis deste repositório; não copie a implementação dos agentes.

Escolha `mistral-vibe` ou `gemini` e configure somente a chave correspondente. Sem a chave, o agente é ignorado; o CI determinístico continua funcionando normalmente.

## 3. (Opcional) Configure o GitHub App

Para comentários e PRs automáticos, crie um GitHub App, instale-o no projeto e configure `GH_APP_ID` e `GH_APP_PRIVATE_KEY`. Consulte [secrets.md](secrets.md).

## 4. Teste

Abra um PR e confirme que o CI roda. Habilite agentes separadamente e verifique seus logs. Não execute automações de edição em repositórios cujo código ou scripts não sejam confiáveis.

## 5. Fixe uma versão

Durante o desenvolvimento, os callers podem usar `@main` para acompanhar as alterações deste repositório. Depois de validar uma versão estável, publique uma tag e atualize os callers para essa referência. Para máxima previsibilidade, use um SHA completo.

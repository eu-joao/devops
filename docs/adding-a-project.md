# Adicionando um projeto

## 1. Configure somente o CI

Copie `templates/callers/ci.yml` para `.github/workflows/ci.yml`. Ajuste os diretórios e remova jobs que o projeto não usa.

- Vue/React/Node: `ci-node.yml`.
- Spring Boot/Maven: `ci-spring.yml`.

Não é necessário configurar secrets, GitHub App ou agente para usar CI.

## 2. (Opcional) Habilite agentes

Escolha `mistral-vibe` ou `gemini`, configure somente a chave correspondente e copie os callers de review, triagem ou dependências que desejar. Sem a chave, o agente é ignorado; o CI independente continua funcionando.

## 3. (Opcional) Configure o GitHub App

Para comentários e PRs automáticos, crie um GitHub App, instale-o no projeto e configure `GH_APP_CLIENT_ID` e `GH_APP_PRIVATE_KEY`. Consulte [secrets.md](secrets.md).

## 4. Teste

Abra um PR e confirme que o CI roda. Habilite agentes separadamente e verifique seus logs. Não execute automações de edição em repositórios cujo código ou scripts não sejam confiáveis.

## 5. Fixe uma versão

Durante desenvolvimento, os callers podem usar `@main`. Depois de validar uma versão estável, publique uma tag e atualize os callers para ela.

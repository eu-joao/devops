# Adicionando um projeto

Passo a passo para ligar um projeto novo aos workflows deste repositório.

## 1. Criar o secret

No repositório do projeto, vá em **Settings > Secrets and variables > Actions** e crie o secret `AGENT_API_KEY` com a chave de API do agente escolhido. Veja [secrets.md](./secrets.md).

## 2. Ajustar as configurações do Actions

Em **Settings > Actions > General > Workflow permissions**, ative **Allow GitHub Actions to create and approve pull requests**. Só é preciso para o workflow de dependências.

## 3. Copiar os arquivos de chamada

Copie de `templates/callers/` para `.github/workflows/` do projeto os arquivos que quiser usar:

- `ci.yml`: build e testes;
- `review.yml`: review de PR por agente;
- `deps.yml`: atualização semanal de dependências;
- `triage.yml`: triagem de issues (opcional).

Em cada arquivo, troque `SEU_USUARIO` pelo seu usuário do GitHub. No `ci.yml`, ajuste `working_directory` e apague o job que o projeto não usa.

## 4. Escolher o agente

O campo `agent_cli` aceita `claude`, `codex`, `gemini` ou `vibe`. O secret `AGENT_API_KEY` precisa ser a chave do provedor desse CLI. Para trocar de agente, mude `agent_cli` e o valor do secret.

## 5. Testar

Abra um PR de teste e confira se o comentário do review aparece. Para dependências, rode o workflow manualmente em **Actions > Atualizar dependências > Run workflow**.

## 6. Fixar uma versão

Com tudo funcionando, crie uma tag neste repositório e use-a nos projetos, para que uma mudança aqui não quebre todos de uma vez:

```bash
git tag v1
git push origin v1
```

Nos arquivos de chamada, troque `@main` por `@v1` e `devops_ref: main` por `devops_ref: v1`. Os dois precisam ser trocados juntos.

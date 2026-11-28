---
name: commit-push-pr
description: "Commit, push e abre um PR seguindo o CONTRIBUTING.md do repositório e usando vocabulário simples. Use quando o usuário pedir commit, push, PR ou disser “sobe isso”."
---

# Commit, push e PR

O fluxo organiza alterações, cria commits e publica um pull request conforme as convenções do repositório.

## Passo 1 — Coletar contexto

Consulte:

- `git status`
- `git diff HEAD`
- `git branch --show-current`
- `git log -5 --oneline`
- `git remote get-url origin`
- `gh auth status`
- `CONTRIBUTING.md` e `.github/pull_request_template.md`, quando existirem

Se o comando `gh` não existir ou não estiver autenticado, siga o plano B.

## Passo 2 — Conferir as convenções

Consulte o `CONTRIBUTING.md` e o template de PR para identificar:

- Estratégia de branches e branch-base.
- Formato do nome da branch, se definido.
- Convenção de mensagens de commit.
- Seções e ordem exigidas na descrição do PR.
- Forma de referenciar a issue.

Se não houver convenção documentada, pergunte ao usuário antes de inventar uma.

## Passo 3 — Executar

1. **Branch:** siga a estratégia documentada pelo repositório. Em Trunk-Based Development, crie uma branch curta e descritiva a partir de `main`, sem exigir número de issue. Não crie branches permanentes de integração.
2. **Stage:** adicione apenas os arquivos relacionados à tarefa. Não inclua arquivos sensíveis, saídas de build ou alterações alheias.
3. **Commits:** agrupe alterações por escopo e responsabilidade. Faça commits separados quando houver unidades independentes, sem criar um commit por arquivo. Respeite o formato, o idioma e os limites definidos pelo repositório.
4. **Coautoria:** quando a IA tiver contribuído de forma relevante, inclua o trailer de coautoria com a identidade configurada pelo usuário ou pela ferramenta. Não invente nome ou endereço de e-mail.
5. **Push:** publique com `git push -u origin <branch>`. Nunca use `--force`.
6. **PR:** abra o PR para a branch-base definida pelo repositório (em Trunk-Based Development, `main`) e use o template. Use `--draft` quando solicitado.
7. **Limpeza:** após o merge, exclua a branch de trabalho quando não houver motivo para mantê-la.

Não faça push, publique branches ou abra PR sem solicitação explícita do usuário.

## Plano B — sem GitHub CLI

Se `gh` não estiver disponível ou autenticado, não tente criar o PR. Entregue:

- Título e descrição do PR conforme as convenções do repositório.
- Link de comparação montado a partir do endereço do remote.
- Motivo pelo qual o PR não foi criado e a orientação `gh auth login`, quando aplicável.

Se o remote não for do GitHub, entregue apenas o título e a descrição.

## Texto do PR

Use linguagem simples e direta:

- Diga o que mudou e por quê, sem repetir o título da issue.
- Evite frases longas, termos rebuscados e seções desnecessárias.
- Não inclua seções de testes ou notas se o template não pedir.

Se não houver template nem convenção, use:

```text
[TIPO] Título curto no imperativo

O que mudou?
<1 a 3 frases explicando a alteração>

Issue: <#número ou N/A>
Outras dependências: <N/A ou lista>
```

## Resposta final

Informe o link do PR ou de comparação, a branch e as mensagens dos commits. Inclua o trailer de coautoria quando houver.

## Sem acesso ao repositório

Se não houver acesso ao repositório ou ao terminal, não simule a execução. Entregue os comandos necessários e o texto do PR para o usuário executar.

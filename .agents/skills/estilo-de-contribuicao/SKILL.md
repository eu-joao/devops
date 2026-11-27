---
name: pr-contributing-style
description: "Redige descrições de PR e explicações do fluxo Git em linguagem simples, seguindo CONTRIBUTING.md e o vocabulário do usuário. Use ao escrever texto de PR, mensagens de commit ou explicar branches, commits e PRs."
---

# Estilo de contribuição e pull requests

Redija textos de contribuição em linguagem simples, seguindo as convenções do repositório.

## 1. Consulte as convenções

Antes de escrever:

1. Consulte o `CONTRIBUTING.md` na raiz.
2. Consulte `.github/pull_request_template.md` e os templates em `.github/PULL_REQUEST_TEMPLATE/`, se existirem.
3. Reaproveite os títulos e a ordem das seções do template aplicável.
4. Confira no `CONTRIBUTING.md` o padrão de branches e mensagens de commit.

Se não houver convenções documentadas, pergunte ao usuário em vez de inventar um padrão.

## 2. Use linguagem simples

- Explique o que mudou e por quê, com frases curtas.
- Não repita o título da issue com outras palavras.
- Evite termos rebuscados, justificativas empilhadas e seções desnecessárias.
- Use o idioma e o vocabulário adotados pelo projeto e pelo usuário.

## 3. Estruture o texto

Se o projeto não tiver template ou convenção, use:

```text
[TIPO] Título curto no imperativo

O que mudou?
<1 a 3 frases explicando a alteração>

Issue: <link ou número>
Outras dependências: <N/A ou lista>
```

Ao explicar um fluxo Git, descreva apenas as etapas necessárias, na ordem em que acontecem.

## 4. Revise antes de finalizar

Remova trechos que:

- Repetem informações já presentes no título ou na issue.
- Usam expressões vagas no lugar de explicar a mudança.
- Acrescentam seções que o projeto não exige.

---
name: pr-contributing-style
description: "Redige descrições de PR e explicações do fluxo Git em linguagem simples, seguindo CONTRIBUTING.md e o vocabulário do usuário. Use ao escrever texto de PR, mensagens de commit ou explicar branches, commits e PRs."
---

# Estilo de contribuição e pull requests

Redige descrições de PR e explicações do fluxo Git em linguagem simples, seguindo as convenções do repositório. Evita textos longos, seções desnecessárias e repetição de contexto.

## 1. Consulte as convenções antes de escrever

Never draft a PR description from a generic template first. Always look for the project's own convention:

1. Look for `CONTRIBUTING.md` at the repo root (ask the user for the repo, or read it if already open/fetched).
2. Look for `.github/pull_request_template.md` and templates in `.github/PULL_REQUEST_TEMPLATE/`.
3. Extract:
   - Section headers from the applicable PR template — reuse the **exact** wording and order, and preserve its comments and checklist items.
   - Commit message convention (type prefixes, language, imperative vs. descriptive) and branch naming convention (e.g. `<issue-number>-<slug>`) from `CONTRIBUTING.md`, when available.
4. If neither a `CONTRIBUTING.md` nor a PR template exists, ask the user once for the convention instead of inventing one. Do not silently default to Conventional Commits or a generic PR template.

## 2. Use linguagem simples

Evite vocabulário rebuscado e excesso de assuntos por seção:

- One idea per sentence. No compound sentences stacking two justifications.
- Say what changed and why in the fewest words that are still specific — not "This PR introduces a comprehensive refactoring of the communication flow documentation to enhance clarity," but "Revisei o texto do fluxo de comunicação entre os repositórios e adicionei o diagrama correspondente."
- Don't restate things obvious from the diff or the issue title.
- Don't add a "Testing" or "Additional notes" section unless the project's CONTRIBUTING.md asks for one, or the user does.
- Prefira a linguagem simples usada pelo usuário e pelo próprio repositório.

## 3. Estruture o texto

Default shape only when no project PR template or section list is available:

```
[TYPE] Short imperative title

O que mudou?
<1-3 sentences, plain language, what changed and why>

Issue: <link or #number>
Outras dependências: <N/A or list>
```

For a **flow explanation** (not a PR), skip the PR headers and just explain the sequence of branch → commits → PR in plain steps, matching the level of vocabulary the user already uses for that project (check prior explanations in this conversation or project notes if available).

## 4. Revise antes de finalizar

Re-read the draft and cut anything that:

- Repeats the issue title in different words
- Uses hedging ("this should", "this may help") instead of stating it directly
- Adds a section the CONTRIBUTING.md doesn't ask for

If the draft is longer than the equivalent info would take to say out loud in one breath, cut it down.

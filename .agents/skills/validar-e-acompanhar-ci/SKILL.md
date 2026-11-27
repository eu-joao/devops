---
name: validar-e-acompanhar-ci
description: Escolhe e executa validações locais conforme as mudanças e acompanha os checks de CI de um pull request, investigando falhas antes de relatar o resultado.
---

# Validar mudanças e acompanhar CI

Use esta skill ao validar mudanças e acompanhar a CI de um pull request relacionado ao trabalho.

## Escolher onde validar

1. Identifique os arquivos e áreas afetados pelo diff. Consulte `AGENTS.md`, `CONTRIBUTING.md`, os guias da área, os scripts e `.github/workflows/` para descobrir as verificações disponíveis.
2. Quando houver CI relevante, prefira executar as verificações nela. Não repita localmente os mesmos testes ou builds sem necessidade.
3. Execute verificações localmente quando não houver CI relevante, quando ela estiver indisponível, quando for necessário investigar uma falha ou quando o usuário pedir. Escolha comandos documentados e mantenha a validação proporcional ao escopo.
4. Se uma verificação falhar, examine a saída e determine se a causa está na mudança, em um problema preexistente ou no ambiente.
5. Registre os comandos executados e seus resultados. Para a CI, registre os checks e seus estados, incluindo links ou identificadores quando disponíveis. Informe o que não foi executado e por quê.

Não invente comandos de teste. Se não houver testes automatizados para a área, informe isso e descreva as outras verificações realizadas.

## Acompanhar CI de pull request

Quando houver um pull request, use `gh` para consultar seu estado e os checks:

```bash
gh pr view <número-ou-branch> --json number,url,statusCheckRollup
gh pr checks <número-ou-branch>
```

Se os checks estiverem em execução, acompanhe com `gh pr checks <número-ou-branch> --watch`. Se algum falhar, obtenha o SHA da branch com `gh pr view`, localize as execuções daquele commit com `gh run list --commit <sha>` e consulte os logs com `gh run view <run-id> --log-failed`.

Investigue as mensagens de erro e relate o check afetado e o diagnóstico. Se `gh` não estiver autenticado, o PR não puder ser localizado ou os logs não estiverem acessíveis, registre a limitação. Não declare a CI aprovada sem evidência.

Não corrija código nem faça merge como parte do acompanhamento da CI; aguarde solicitação explícita para essas ações.

## Relato final

Resuma as mudanças e liste as verificações locais e os checks de CI com seus estados. Para falhas, informe o diagnóstico; para itens pendentes ou bloqueados, explique o motivo e o próximo passo. Confira `git status` e `git diff` antes de concluir.

# Contribuindo

## Organização

- A implementação compartilhada fica em `.github/workflows/`, `agents/`, `scripts/` e `prompts/`.
- Skills compartilhadas ficam em `agents/skills/`; mantenha instruções genéricas e não inclua dependências específicas de um projeto consumidor.
- Templates de contribuição ficam em `.github/ISSUE_TEMPLATE/` e `.github/pull_request_template.md`.
- Projetos consumidores devem precisar apenas de arquivos chamadores pequenos para selecionar workflows e definir eventos e parâmetros. Não reintroduza cópias da implementação nem templates de callers neste repositório.
- Preserve a separação entre CI determinística e automações opcionais com IA. A CI não deve depender de secrets de provedores ou de um GitHub App.
- Agentes não podem receber tokens do GitHub; publicação e comentários devem continuar em etapas separadas, usando o GitHub App.

## Branches

Use `<número-da-issue>-<descrição-curta>`, em minúsculas e separado por hífen.

## Commits

Use `tipo: descrição`, em português e no imperativo. Tipos: `feat`, `fix`, `docs`, `ci`, `chore`.

## Pull Requests

Descreva o que mudou, a issue relacionada e dependências externas. Use o template do repositório. Não faça merge sem revisão humana.

Ao alterar um workflow reutilizável, revise também seus inputs, descrições, permissões e comportamento esperado nos repositórios consumidores. Mantenha as descrições dos inputs: elas facilitam configuração e revisão. Fixe actions externas por SHA completo.

## Validação local

- `shellcheck -x` nos scripts shell.
- `bats tests/agents` para os testes dos scripts.
- `actionlint` nos workflows.
- `zizmor .github/workflows` para análise de segurança.

Os testes automatizados não devem chamar provedores de IA reais nem consumir cotas. Prefira testes com comandos simulados e credenciais fictícias.

## CI

O workflow `.github/workflows/ci-devops.yml` executa as verificações do próprio repositório. A CI dos projetos consumidores é fornecida pelos workflows reutilizáveis específicos de cada stack. Mudanças nesses arquivos devem manter a configuração local dos consumidores mínima e compatível.

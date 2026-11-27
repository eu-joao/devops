# Instruções para agentes

## Orientações gerais

- Antes de alterar arquivos, consulte `README.md`, `CONTRIBUTING.md` e a documentação da área afetada.
- Este repositório mantém workflows reutilizáveis, scripts, documentação e skills compartilhadas. Não adicione configurações específicas de um consumidor sem justificativa.
- Preserve a separação entre CI determinística e automações opcionais com IA.
- Ao alterar workflows reutilizáveis, revise inputs, descrições, permissões, segurança e compatibilidade com consumidores.
- Não copie implementações para consumidores quando um workflow reutilizável puder atender ao caso.
- Mantenha a CI independente de secrets de provedores de IA.

## Skills compartilhadas

Consulte as skills em `agents/skills/` conforme a tarefa:

- `criar-issue`: criar e estruturar issues.
- `commit-push-pr`: preparar commits, publicar branches e abrir pull requests.
- `estilo-de-contribuicao`: seguir o padrão de contribuição do repositório.
- `revisar-pr`: revisar alterações em pull requests.
- `validar-e-acompanhar-ci`: escolher verificações proporcionais, executar validações documentadas e acompanhar os checks de PR.

As skills orientam a execução, mas não autorizam por si só ações externas. Não faça push, publique branches, comente, aprove ou mescle alterações sem solicitação explícita do usuário.

## Validação

Use a skill [validar-e-acompanhar-ci](agents/skills/validar-e-acompanhar-ci/SKILL.md) para escolher verificações proporcionais, executar validações documentadas e acompanhar os checks de PR.

Registre comandos e resultados efetivamente observados. Não declare verificações aprovadas sem evidência.

## Contribuição

Siga [CONTRIBUTING.md](CONTRIBUTING.md) para branches, commits, pull requests e verificações.

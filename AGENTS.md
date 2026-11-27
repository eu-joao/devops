# Instruções para agentes

## Orientações gerais

- Antes de alterar arquivos, consulte README, CONTRIBUTING e a documentação da área afetada.
- Este repositório mantém workflows reutilizáveis, scripts, documentação e skills compartilhadas. Não adicione configurações específicas de um consumidor sem justificativa.
- Preserve a separação entre CI determinística e automações opcionais com IA.
- Ao alterar workflows reutilizáveis, revise inputs, descrições, permissões, segurança e compatibilidade com consumidores.
- Não copie implementações para consumidores quando um workflow reutilizável puder atender ao caso.

## Validação

Use a skill [validar-e-acompanhar-ci](agents/skills/validar-e-acompanhar-ci/SKILL.md) para escolher verificações proporcionais, executar validações documentadas e acompanhar os checks de PR.

Registre comandos e resultados efetivamente observados. Não declare verificações aprovadas sem evidência.

## Contribuição

Siga [CONTRIBUTING.md](CONTRIBUTING.md) para branches, commits, pull requests e verificações.

# devops

Workflows de CI e agentes de IA compartilhados pelos projetos do semestre.

## Sobre

Este repositório concentra os workflows reutilizáveis do GitHub Actions, os prompts e os scripts usados por todos os projetos. Cada projeto chama um workflow daqui com poucas linhas, em vez de copiar a configuração.

Os agentes de IA rodam como CLI dentro do Actions. Para trocar de agente basta mudar uma variável, porque os workflows só chamam o script `run-agent.sh`.

## Estrutura

```
devops/
├── .github/workflows/
│   ├── ci-spring.yml          # build e testes (Spring Boot, Maven)
│   ├── ci-react.yml           # lint, testes e build (React)
│   ├── agent-review-pr.yml    # agente comenta no PR
│   ├── agent-update-deps.yml  # agente atualiza dependências e abre PR
│   └── agent-triage-issue.yml # agente classifica issues
├── prompts/
│   ├── review.md
│   ├── deps.md
│   ├── triage.md
│   └── shared/
│       └── project-rules.md   # regras comuns a todos os prompts
├── scripts/
│   ├── run-agent.sh           # chama o CLI escolhido em modo headless
│   ├── install-agent.sh       # instala o CLI escolhido
│   └── open-pr.sh             # branch, commit, push e gh pr create
├── templates/
│   ├── callers/               # arquivos para copiar em cada projeto
│   ├── Dockerfile.spring
│   ├── Dockerfile.react
│   └── docker-compose.yml
├── docs/
│   ├── adding-a-project.md
│   ├── secrets.md
│   └── permissions.md
├── CONTRIBUTING.md
└── README.md
```

## Como usar

1. Crie o secret `AGENT_API_KEY` no projeto.
2. Copie os arquivos de `templates/callers/` para `.github/workflows/` do projeto e troque `SEU_USUARIO`.
3. Abra um PR de teste.

O passo a passo completo está em [docs/adding-a-project.md](./docs/adding-a-project.md).

## Contribuindo

Regras de branch, commit e Pull Request estão em [CONTRIBUTING.md](./CONTRIBUTING.md).

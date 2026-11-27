# Versões de runtimes e Actions

## Runtimes padrão

Os workflows reutilizáveis compartilham os seguintes padrões, definidos em `.github/workflows/runtime-versions.yml`:

| Runtime | Padrão |
| --- | --- |
| Node.js | 24 |
| Java | Temurin 17 |

Os workflows consumidores aceitam `node_version` e/ou `java_version` como inputs opcionais. Quando omitidos ou vazios, o resolvedor fornece os padrões acima. A sobrescrita deve ser usada apenas quando houver requisito de compatibilidade do projeto. O resolvedor é chamado por caminho relativo (`./.github/workflows/runtime-versions.yml`), portanto acompanha automaticamente a mesma branch, tag ou SHA do workflow consumidor.

Workflows que herdam os padrões:

- Node genérico: `ci-node.yml`
- Expo / React Native: `ci-mobile-expo.yml`
- Next.js: `ci-nextjs.yml`
- Commitlint: `ci-commitlint.yml`
- Spring Boot: `ci-spring.yml`
- Atualização de dependências: `agent-update-deps.yml`

## GitHub Actions

As Actions externas são fixadas por SHA completo, não por tags mutáveis. As referências atualmente compartilhadas são:

| Action | Versão fixada |
| --- | --- |
| `actions/checkout` | v7.0.1 |
| `actions/setup-node` | v7.1.0 |
| `actions/setup-java` | v6.3.0 |
| `actions/create-github-app-token` | v3.4.0 |
| `rhysd/actionlint` | imagem Docker fixada por digest |

Ao atualizar uma Action:

1. Verifique a versão estável e o respectivo SHA completo.
2. Atualize todas as ocorrências da mesma Action nos workflows.
3. Atualize o comentário de versão junto ao SHA.
4. Execute as verificações do repositório para validar sintaxe e consistência.

O GitHub Actions exige que cada uso declare sua própria referência `uses`; por isso, as referências são repetidas nos workflows, mas devem permanecer idênticas para a mesma Action.

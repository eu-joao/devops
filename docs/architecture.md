# Arquitetura

## Princípios

1. CI determinístico não depende de IA, credenciais de provedor ou GitHub App.
2. Agentes são opcionais e só são executados quando existe uma chave para o provedor selecionado.
3. Provedor, autenticação e execução são camadas distintas.
4. O processo do agente nunca recebe `GITHUB_TOKEN`, token de instalação do App ou credenciais de publicação.
5. Automação determinística deve ser preferida quando resolve o problema sem IA.
6. CD permanece fora do escopo até CI estável.

## Componentes

- `.github/workflows/`: orquestração de CI e tarefas de agentes.
- `agents/auth/`: resolve a variável de ambiente adequada ao provedor.
- `agents/providers/`: encapsula flags e comandos específicos de cada CLI.
- `agents/runtime/`: valida entradas, monta prompt, aplica timeout e grava saída.
- `prompts/`: instruções versionadas e regras comuns.
- `scripts/`: tarefas determinísticas de instalação e publicação.
- `templates/callers/`: exemplos mínimos para projetos consumidores.
- `tests/`: testes locais sem chamadas reais a modelos.

## Provedores suportados

| Provider | Autenticação headless | Secret |
|---|---|---|
| `mistral-vibe` | chave do Vibe Code | `MISTRAL_VIBE_CODE_KEY` |
| `gemini` | Gemini API key | `GEMINI_API_KEY` |

Mistral Vibe é o padrão recomendado. A disponibilidade e os limites gratuitos dependem do plano do provedor e devem ser conferidos na conta. A chave gratuita do Gemini pode estar sujeita a termos de uso de dados diferentes de planos pagos; não habilite em repositórios privados sem avaliar esses termos.

## Fluxo de execução

1. Workflow verifica evento e permissões.
2. Checkout do projeto com `persist-credentials: false`.
3. Checkout dos prompts/scripts.
4. Runtime resolve a chave do provedor. Sem chave: aviso e saída sem executar agente.
5. CLI executa em modo read-only ou edit, com timeout.
6. Somente após o agente terminar, um GitHub App token pode ser criado para comentar ou publicar PR.
7. O agente não tem acesso ao token do App.

## CI

- `ci-node.yml` atende Vue, React e projetos Node usando scripts declarados no `package.json`.
- `ci-spring.yml` atende projetos Maven/Spring.
- `ci-devops.yml` testa os próprios scripts e workflows.
- Projetos podem consumir somente CI; não precisam configurar secrets de IA.

## Evolução

Não criar abstrações ou composite actions para comandos triviais. Extrair uma action apenas quando houver lógica estável repetida em múltiplos workflows. Actions externas são fixadas por SHA completo; atualizações devem ocorrer em PR e passar pelo CI. Os callers dos workflows deste repositório podem usar `@main` durante desenvolvimento.

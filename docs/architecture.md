# Arquitetura

## Princípios

1. CI determinística não depende de IA, credenciais de provedor ou GitHub App.
2. Agentes são opcionais e só são executados quando existe uma chave para o provedor selecionado.
3. Provedor, autenticação e execução são camadas distintas.
4. O processo do agente nunca recebe `GITHUB_TOKEN`, token de instalação do App ou credenciais de publicação.
5. Automação determinística deve ser preferida quando resolve o problema sem IA.
6. CD permanece fora do escopo até CI estável.

## Componentes

- `.github/workflows/`: workflows reutilizáveis de CI e tarefas de agentes, além da CI deste repositório.
- `agents/auth/`: resolve a variável de ambiente adequada ao provedor.
- `agents/providers/`: encapsula flags e comandos específicos de cada CLI.
- `agents/runtime/`: valida entradas, monta prompt, aplica timeout e grava saída.
- `prompts/`: instruções versionadas e regras comuns.
- `scripts/`: tarefas determinísticas de instalação e publicação.
- `templates/`: templates de container; não são necessários para consumir os workflows.
- `tests/`: testes locais sem chamadas reais a modelos.

## Consumo dos workflows

Os projetos consumidores mantêm somente arquivos em `.github/workflows/` que definem os eventos e chamam os workflows deste repositório por meio de `jobs.<job_id>.uses`. Esses arquivos locais são pontos de entrada e configuração, não cópias da implementação.

O repositório central mantém a lógica de execução, instalação de ferramentas, testes, build, scripts e prompts. Alterações nessa implementação são feitas aqui e passam a valer para os consumidores conforme a referência utilizada (`@main`, tag ou SHA).

## Provedores suportados

| Provider | Autenticação headless | Secret |
|---|---|---|
| `mistral-vibe` | chave do Vibe Code | `MISTRAL_VIBE_CODE_KEY` |
| `gemini` | Gemini API key | `GEMINI_API_KEY` |

Mistral Vibe é o padrão recomendado. A disponibilidade e os limites dependem do plano do provedor e devem ser conferidos na conta. Para Gemini, verifique os termos de tratamento de dados do nível gratuito antes de enviar código privado.

## Fluxo de execução dos agentes

1. O workflow verifica evento e permissões.
2. O código do projeto é obtido com `persist-credentials: false`.
3. O repositório compartilhado é obtido na referência definida por `devops_ref`.
4. O runtime resolve a chave do provedor. Sem chave: aviso e saída sem executar agente.
5. A CLI executa em modo read-only ou edit, com timeout.
6. Somente após o agente terminar, um token do GitHub App pode ser criado para comentar ou publicar PR.
7. O agente não tem acesso ao token do App.

## Workflows de CI

- `ci-node.yml` atende Vue, React e projetos Node usando scripts declarados no `package.json`.
- `ci-spring.yml` atende projetos Maven/Spring.
- `ci-devops.yml` testa os próprios scripts e workflows.

Projetos consumidores podem usar somente CI; não precisam configurar secrets de IA nem GitHub App.

## Evolução

Não criar abstrações ou composite actions para comandos triviais. Extrair uma action apenas quando houver lógica estável repetida em múltiplos workflows. Actions externas são fixadas por SHA completo; atualizações devem ocorrer em PR e passar pelo CI. Os consumidores podem usar `@main` durante desenvolvimento, mas tags ou SHAs completos oferecem maior previsibilidade.

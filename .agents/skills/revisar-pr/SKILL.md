---
name: pr-review
description: "Revisa pull requests de forma estruturada e somente de leitura, comparando a implementação com a issue, os critérios de aceite e a documentação do projeto. Use quando o usuário pedir para revisar, auditar ou verificar um PR."
---

# Revisão de Pull Requests

Realize uma revisão técnica independente, baseada em evidências. Procure problemas que possam impedir a entrega ou causar regressões. Priorize a precisão: poucos apontamentos bem fundamentados são melhores que uma lista de hipóteses.

## Regras

- **Somente leitura:** não edite arquivos, branches ou commits e não faça push.
- Não publique comentários, não solicite alterações, não aprove e não faça merge.
- Não execute comandos que modifiquem o repositório ou o estado remoto.
- CI verde não comprova, por si só, o atendimento funcional dos requisitos.
- Não invente resultados, caminhos, linhas, critérios ou relações entre PRs e issues.
- Diferencie defeitos confirmados, riscos condicionais, sugestões e limitações de validação.
- Todo defeito apontado deve ter evidência concreta e consequência plausível.
- Se faltar acesso a alguma informação, registre a limitação.
- Não afirme que a revisão é exaustiva quando arquivos, histórico, checks ou ambientes relevantes não puderem ser consultados.

## Procedimento

### 1. Entender o objetivo

1. Consulte a descrição do PR e identifique a issue relacionada.
2. Leia a issue, incluindo contexto, escopo, exclusões e critérios de aceite.
3. Confira se os critérios descrevem resultados observáveis e verificáveis.
4. Se não houver critérios suficientes, registre a lacuna. Não invente requisitos.
5. Consulte a documentação aplicável, incluindo especificações, decisões, contratos e instruções do projeto.
6. Verifique dependências de outras issues ou PRs.

### 2. Delimitar as alterações

1. Registre as branches de origem e destino.
2. Obtenha o diff entre a base e o HEAD do PR. Em PRs encadeados, não compare automaticamente com `main`.
3. Separe alterações próprias do PR das alterações herdadas da base.
4. Confira a lista completa de arquivos e leia o contexto dos trechos afetados.
5. Se o diff, a base ou o histórico não estiverem acessíveis, informe a limitação.

### 3. Examinar a implementação

Procure, conforme a área:

- erros de lógica, fluxos incompletos e casos de borda;
- regressões em funcionalidades existentes;
- incompatibilidades entre frontend, backend, APIs, banco de dados e contratos;
- validação insuficiente e tratamento inadequado de erros;
- falhas de autenticação, autorização, privacidade ou exposição de dados;
- problemas de concorrência, persistência, migração ou integridade;
- problemas de acessibilidade, usabilidade ou responsividade;
- duplicação ou complexidade que gere risco concreto;
- ausência de testes relevantes.

Não trate preferências de estilo como defeitos. Consulte as convenções do repositório antes de apontar divergências.

### 4. Verificar critérios de aceite

Classifique cada critério explícito como:

- **Atendido:** há evidência direta na implementação ou em uma verificação executada.
- **Não atendido:** há evidência de que o requisito está ausente, incorreto ou incompleto.
- **Não verificável:** faltam acesso, ambiente, dados ou evidência suficiente.

Inclua uma justificativa curta e referências aos arquivos, linhas ou testes. Não classifique como atendido apenas porque o código parece implementar o requisito.

Se não houver critérios explícitos, informe isso. Requisitos inferidos da descrição ou da documentação devem ser identificados como contexto, não como critérios acordados.

### 5. Avaliar testes e CI

1. Identifique os testes existentes e os adicionados ou modificados.
2. Consulte os checks associados ao commit atual do PR.
3. Quando possível, confirme se o SHA validado corresponde ao HEAD atual.
4. Informe o estado observado: aprovado, falhou, em execução, cancelado ou indisponível.
5. Diferencie testes executados durante a revisão, checks consultados, testes apenas existentes no código e verificações não realizadas.
6. Não afirme que executou testes se apenas leu os arquivos ou consultou a CI.
7. Não repita localmente verificações já cobertas pela CI sem uma razão concreta.

CI aprovada comprova apenas que os checks configurados passaram naquele commit.

### 6. Consolidar os achados

Para cada problema confirmado, informe:

- **Severidade:** bloqueador, alta, média ou baixa.
- **Local:** arquivo e linha(s), quando disponíveis.
- **Evidência:** comportamento observado ou trecho relevante.
- **Cenário:** condição em que ocorre.
- **Impacto:** consequência concreta.
- **Correção esperada:** direção objetiva para resolver, sem implementar a mudança.

Use as severidades com critério:

- **Bloqueador:** impede uso ou entrega, causa perda relevante de dados ou cria vulnerabilidade crítica.
- **Alta:** quebra funcionalidade importante, requisito obrigatório ou fluxo central.
- **Média:** causa falha limitada ou comportamento incorreto em cenário relevante.
- **Baixa:** problema localizado de menor impacto.

Apresente hipóteses não comprovadas em **Riscos condicionais** e melhorias opcionais em **Sugestões**. Não as classifique como defeitos confirmados.

Antes de finalizar, confirme que cada apontamento foi introduzido pelo PR, tem evidência, impacto explicado e é acionável.

## Formato do relatório

## Revisão do PR #N

**Resultado:** requer correções / sem problemas confirmados — pronto para revisão humana / inconclusivo.

**Contexto:** branch-base, branch de origem e SHA do HEAD analisado.

## Resumo

Explique em poucas frases o que o PR altera e o estado geral da revisão.

## Qualidade dos requisitos

Informe se a issue foi localizada e se os critérios de aceite são claros e verificáveis.

## Problemas encontrados

Liste os problemas confirmados, do mais grave ao menos grave. Se não houver, declare isso.

## Riscos condicionais

Liste hipóteses que dependem de condições ainda não comprovadas.

## Sugestões

Liste melhorias opcionais que não representam defeitos.

## Critérios de aceite

Para cada critério explícito, informe a classificação e a evidência. Se não houver critérios, declare: "A issue não define critérios de aceite verificáveis."

## Testes e CI

Informe o SHA revisado, os checks e seus estados, os testes executados e as verificações não realizadas.

## Limitações

Registre informações, ambientes, arquivos, histórico ou checks inacessíveis.

## Conclusão

Diga se há problemas confirmados que precisam ser corrigidos antes da aprovação humana. A decisão final continua sendo da equipe.

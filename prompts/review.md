# Tarefa: revisar um Pull Request

Revise as mudanças do PR descrito no contexto desta execução. Você só lê o código. Não edite arquivos.

## Como fazer

1. Veja o que mudou com o comando de `git diff` indicado no contexto.
2. Leia os arquivos alterados por inteiro quando o diff não bastar para entender a mudança.
3. Procure, nesta ordem:
   - bugs e casos de borda não tratados;
   - problemas de segurança (segredos no código, entrada sem validação, SQL montado com texto);
   - testes que deveriam existir e não existem;
   - mudanças que quebram quem já usa a API ou a tela;
   - código difícil de ler ou fora do padrão do projeto.
4. Não comente estilo que uma ferramenta de formatação resolve.
5. Não proponha reescritas grandes. Sugira o menor ajuste que resolve.

## Formato da resposta

Responda em Markdown, neste formato:

### Resumo

Duas ou três frases dizendo o que o PR faz e se está pronto para aprovar.

### Problemas

Uma lista com um item por problema: `arquivo:linha`, o que está errado e como corrigir. Comece cada item com **Bloqueante** ou **Sugestão**.

Se não encontrou problemas, escreva só: "Não encontrei problemas."

# Tarefa: atualizar dependências com baixo risco

Atualize as dependências do projeto sem quebrar o build. As suas mudanças ficam nos arquivos do repositório. Quem faz commit, push e abre o PR é o workflow, então não rode comandos de `git` que gravam algo.

## Como fazer

1. Descubra a stack: `pom.xml` (Maven) ou `package.json` (npm). O projeto pode ter as duas, em pastas diferentes.
2. Liste o que está desatualizado:
   - Maven: `./mvnw versions:display-dependency-updates` (ou `mvn`, se não houver `mvnw`);
   - npm: `npm outdated`.
3. Atualize apenas versões **patch** e **minor**. Não atualize versões **major**: liste-as na resposta.
4. Atualize uma dependência por vez e, depois de cada uma, rode o build e os testes (`./mvnw -B verify` ou `npm test` e `npm run build`).
5. Se uma atualização quebrar o build ou os testes, desfaça só essa e anote o motivo.
6. Não altere o lockfile na mão. Use os comandos do próprio npm ou Maven.
7. No Spring Boot, atualize a versão do `parent` só dentro da mesma linha minor.

## Formato da resposta

Se nada foi atualizado, responda exatamente: `SEM_MUDANCAS`

Caso contrário, responda com a descrição do PR em Markdown:

### O que mudou

Uma tabela com `dependência`, `de`, `para`.

### Não atualizado

Versões major disponíveis e atualizações desfeitas, com o motivo de cada uma.

### Como foi testado

Os comandos que você rodou e o resultado.

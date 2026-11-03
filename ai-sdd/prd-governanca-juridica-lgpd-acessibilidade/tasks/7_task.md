# Tarefa 7.0: Cadastro direto com proteção por padrão

> Referências: [PRD](../prd.md), [Tech Spec](../techspec.md), [Design](../design.md).

## Visão Geral

Aplicar a opção 1 escolhida pelo usuário em 03/11/2026: manter cadastro direto, idade, escolaridade e cidade, com proteção igual para todas as idades. Não criar etapa de aprovação de responsáveis.

## Requisitos Atendidos

RF-004 a RF-009, RF-013 e RF-018 parcialmente. A avaliação de bases legais e medidas de supervisão não é substituída por esta tarefa.

## Design de Referência

Telas 4, 6 e 7 existentes, origem Texto/Código. Ranking existente recebe código automático em vez do nome. Canal de privacidade aparece no documento, cadastro e perfil sem novo formulário.

## Conformidade com Standards

Rails nativo, model, migração reversível, i18n, Minitest/fixtures, sem novas dependências web e sem JS inline.

## Subtarefas

- [x] 7.1 Registrar decisão e avaliar finalidades, necessidade e riscos sem presumir base legal validada.
- [x] 7.2 Criar código de ranking gerado no servidor para contas novas e existentes; preservar dados pessoais e pontuação.
- [x] 7.3 Atualizar responsável, contato, versão e explicações no cadastro, perfil e documentos.
- [x] 7.4 Proteger cache de páginas com dados e relatórios administrativos.
- [x] 7.5 Documentar o atendimento e preparar o PDF com textos e pendências.
- [x] 7.6 Validar cadastro direto, campos preservados, privacidade do ranking, leitura pública e checks obrigatórios.

## Detalhes de Implementação

Ver evolução de 03/11/2026 da Tech Spec. Códigos são pseudônimos, não anonimização. Dados para pesquisa futura não recebem autorização retroativa. Cidade e escolaridade mantêm a opcionalidade da versão existente; idade e limites atuais são preservados.

## Critérios de Sucesso

- [x] Não há nova etapa entre cadastro válido e jogo.
- [x] Ranking não expõe nome ou e-mail de outros estudantes.
- [x] Todos os campos existentes e valores são preservados.
- [x] Contato real aparece como link de e-mail, sem alegação de mensagem enviada pelo site.
- [x] Testes novos passam e resultados gerais ficam documentados.

## Testes

### Model/integração
- [x] Geração do código, conservação no perfil e rejeição de parâmetro forjado.
- [x] Cadastro de estudante menor segue diretamente ao jogo com os campos atuais.
- [x] Ranking, inclusive após mudança de nome, não mostra identidade dos participantes.
- [x] Documentos atuais exibem responsável, contato e pendências reais.

### E2E
- [x] Cadastro e ranking no navegador; documentos e perfil permanecem utilizáveis.

## Arquivos Relevantes

User, migração de ranking_code, views do ranking, cadastro, perfil, partial de contato, locales, testes, README e documentos AI-SDD.

## Dependências

Tarefas 1 a 5 implementadas. Tarefa 6 não é declarada concluída: sua proposta anterior de autorização externa foi substituída pela avaliação da opção 1.

## Resultado — 03/11/2026

Implementação técnica concluída. A suíte de aplicação passou com 97 testes e 581 assertions; os cinco arquivos E2E da entrega passaram com 6 testes e 40 assertions. PDF de 12 páginas conferido visualmente. Resultados de lint, segurança e limitações estão no [registro de validação](../tasks.md#validação-técnica-da-opção-1--03112026). A avaliação jurídica e a execução do atendimento continuam pendentes, conforme os documentos próprios.

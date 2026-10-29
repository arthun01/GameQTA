# Tech Spec - Governança Jurídica, LGPD e Acessibilidade

## Resumo Executivo

A entrega inicial abaixo especifica o tópico 1 do [PRD](prd.md). As páginas públicas de documentos serão recursos de leitura com controllers REST, views ERB e textos em i18n. O usuário autorizou a implementação direta, adiando o Paper e o acabamento visual pelo colaborador. As respostas sobre responsável, contato, público e infraestrutura registradas no PRD orientam esta entrega; nenhuma identidade, base legal ou política de retenção será inventada.

A evolução para o tópico 2 está descrita ao final deste documento. Os tópicos 3 e 4 permanecem pendentes. A entrega inicial não incluiu migrações, aceite ou exclusão.

## Design de Referência

Ver [design.md](design.md): telas 1 e 2 (documentos) e 3 (navegação), com origem Código e variantes mobile, desktop e impressão. Paper adiado por decisão do usuário; sem artboards criados ou declarados aprovados.

## Arquitetura do Sistema

### Visão Geral dos Componentes

- **TermsController e PrivacyPoliciesController:** novos controllers públicos, herdando diretamente de ApplicationController, com ação `show` e layout `legal`.
- **Views e layout:** novas entradas dos dois recursos e partial de documento compartilhado; leitura organizada por seções, título, metadados e indicação de minuta.
- **Locales:** novo `config/locales/pt-BR/legal.yml`, contendo metadados, resumos, seções, listas, referências e textos de navegação. Conteúdo renderizado com escape padrão do ERB, sem HTML confiável vindo de parâmetros.
- **Impressão:** CSS próprio, restrito à classe da página jurídica. Usa `@media print`, remove navegação e mantém conteúdo e pendências.
- **Navegação compartilhada:** partial com links nos layouts estudantil, administrativo e padrão. Os novos links abrem em outra aba para preservar o contexto do usuário; a troca entre documentos na área jurídica ocorre na mesma aba.
- **Documentação e testes:** README, índice de documentação, tasks e testes de integração/sistema atualizados com o escopo efetivamente entregue.

O fluxo é GET → controller público → view do recurso → partial e traduções → HTML. Não depende de consulta ao banco, login, Paper, serviços externos ou JavaScript para exibir os documentos.

## Design de Implementação

### Interfaces Principais

Cada recurso usa a mesma estrutura de tradução: título, subtítulo, versão, data, resumo e seções identificadas por chaves estáveis. O partial recebe uma chave fixa da própria view, nunca do usuário. IDs derivados das chaves das seções permitem navegação pelo índice.

RF-007 será atendido nesta etapa por versão e data explícitas e histórico no Git. Comunicação de alterações e conservação das versões associadas ao aceite dependem do tópico 2; não serão declaradas concluídas com estas páginas.

### Modelos de Dados

Não há novos models, tabelas ou migrações. Os documentos são conteúdo versionado junto à aplicação. Dados atuais são inventariados no texto: cadastro estudantil e administrativo, credenciais protegidas, sessões, IP, navegador, tentativas, respostas, pontuações, tempo e situação de bloqueio.

### Endpoints / Rotas

| Método | Rota | Controller#Action | RF |
|--------|------|-------------------|----|
| GET | `/termos` | `terms#show` | RF-001 a RF-003, RF-007, RF-008 |
| GET | `/privacidade` | `privacy_policies#show` | RF-001, RF-002, RF-004 a RF-008 |

Recursos singulares com `only: :show` e caminhos em português. Acesso independente das sessões Admin e User; nenhuma permissão administrativa é alterada.

## Pontos de Integração

Nenhuma nova integração externa. As páginas descrevem YouTube, Google Fonts, ranking e exportações encontrados no código sem afirmar que seus impactos de privacidade já foram corrigidos. Na área jurídica, usar assets e fontes locais, evitando novos pedidos externos. Referências legais são links que o visitante decide abrir.

## Abordagem de Testes

### Testes Unitários

Não se aplicam: não existe nova regra de domínio ou model. Testar o resultado público pelos testes de integração.

### Testes de Integração

Testar acesso anônimo aos dois documentos, ausência de criação de sessões ou contas, conteúdo de minuta e contato pendente, metadados, referências, navegação interna e presença dos links nos logins, cadastro e páginas autenticadas dos dois perfis. Conferir ausência de formulários de consentimento ou atendimento inexistentes nas páginas jurídicas.

### Testes E2E

Navegar do login aos documentos e entre eles; usar índice de seções; verificar viewport móvel sem rolagem horizontal; emular mídia de impressão para confirmar ocultação de menus, preservação do aviso de minuta e do texto. O sistema operacional já dispõe de Chromium e ChromeDriver.

## Sequenciamento de Desenvolvimento

### Ordem de Construção

1. Documentos públicos e traduções com testes de integração.
2. Links nos layouts, impressão e testes de navegador.
3. Atualizar documentação e registrar resultados e limitações.

### Dependências Técnicas

Usar Rails 8.1, Propshaft, Tailwind, Minitest e Capybara já presentes no projeto. Nenhuma gem nova, configuração MCP ou instalação de pacote é necessária.

## Monitoramento e Observabilidade

Usar logs HTTP existentes e conferir resposta 200 de ambas as rotas. Não adicionar captura de dados, analytics ou registro de aceite ao abrir um documento. Erros de tradução e referências quebradas devem ser detectados pelos testes.

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas rejeitadas |
|---------|---------|---------------|------------------------|
| Leitura pública | Dois recursos REST `show` | Independência dos dois logins | Controllers administrativos ou ações customizadas |
| Conteúdo | Traduções versionadas no repositório | i18n e revisão por diff | Texto hardcoded nas views ou CMS nesta etapa |
| Reuso | Partial do documento e dos links | Mesmo conteúdo e navegação nos contextos | Duplicar todos os documentos por layout |
| Impressão | CSS e comando nativo do navegador | Sem dependência de JavaScript ou PDF no servidor | Serviço externo de conversão |
| Contato indefinido | Aviso explícito de pendência | Não simular atendimento | E-mail fictício ou formulário sem destino |

### Riscos Conhecidos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Minuta confundida com conformidade concluída | Média | Alto | Aviso em ambos os documentos, inclusive na impressão |
| Descrição divergir da aplicação | Média | Alto | Inventário do código e revisão dos textos junto às mudanças futuras |
| Documento cortar na impressão | Média | Médio | Sem altura fixa/overflow oculto e teste em mídia de impressão |
| Pendências anteriores bloquearem checagens | Conhecida | Médio | Registrar separadamente resultados novos e anteriores |

### Conformidade com Standards do Projeto

Aplicar `crud-patterns`, `rails-components`, `rails-visual-design` e `testing-patterns`: controllers finos, ERB, i18n, identidade existente e Minitest com fixtures. Sem service objects, JS inline ou edição de schema. O usuário autorizou pular o protótipo Paper e seguir diretamente à implementação; essa decisão substitui os pontos de espera relacionados a essa etapa.

### Arquivos Relevantes e Dependentes

- Novos: controllers e views dos dois recursos, layout `legal`, partials, stylesheet jurídico, locale e testes.
- Modificados: `config/routes.rb`, três layouts de aplicação, README, índice de documentação e acompanhamento AI-SDD.
- Consultados: models, autenticação, ranking, relatórios e integrações de vídeo/fontes.

Referências consultadas: [rotas Rails 8.1](https://api.rubyonrails.org/v8.1.3/classes/ActionDispatch/Routing/Mapper/Resources.html), [direitos dos titulares — ANPD](https://www.gov.br/anpd/pt-br/assuntos/titular-de-dados/direito-dos-titulares), [orientações da ANPD](https://www.gov.br/anpd/pt-br/acesso-a-informacao/perguntas-frequentes) e [CSS para mídia de impressão — W3C](https://www.w3.org/TR/mediaqueries-3/). As referências subsidiam a minuta e não substituem as decisões e validações pendentes do PRD.


## Evolução do tópico 2 — em andamento

O usuário autorizou prosseguir com aceite, edição do perfil e exclusão, mantendo o e-mail de atendimento pendente. A definição do mecanismo de autorização dos responsáveis foi solicitada pelo usuário e está em esclarecimento; essa parte não será tratada como concluída por um checkbox.

### Arquitetura e interfaces

`Users::ProfilesController` oferece `show`, `edit`, `update` e `destroy` do recurso singular `/perfil`, sempre através de `Current.user`. ID de terceiros e atributos administrativos não são aceitos. Formulários HTML funcionam sem JavaScript; atualização e exclusão exigem senha atual, e a exclusão exige confirmação explícita adicional. Respostas do perfil são `no-store`. Os limites de tentativas reduzem tentativas de adivinhação de senha.

`User#update_profile` e `User#erase_account` mantêm as decisões no domínio e executam sob lock da conta. A exclusão remove sessões, tentativas, respostas, ranking e os próprios aceites, em transação. Não há retenção presumida de dados pessoais para auditoria. Falha na confirmação ou senha mantém a conta e seus dados intactos.

O job existente de ranking passa a chamar `User#update_leaderboard`, sob o mesmo lock usado em exclusão e bloqueio. Conta ausente ou bloqueada não recebe atualização; a corrida entre consulta e lock de conta excluída é descartada. Os cálculos de pontuação e tempo são preservados. As FKs existentes continuam presentes; novas migrações não as removem.

### Dados e minimização

Nome identifica a conta, e-mail e hash de senha permitem autenticação e idade orienta o tratamento por faixa etária. CPF, documentos, telefone, biometria e localização precisa não serão adicionados ao cadastro geral. Cidade e escolaridade são utilizadas em relatórios administrativos, mas não pela mecânica do jogo; passam a ser opcionais, com possibilidade de remover os valores pelo perfil. A migração permite NULL nesses campos e conserva os valores já informados. A finalidade e a necessidade dos registros de desempenho constam do tópico 1.

Validações de e-mail, comprimento dos campos, idade inteira entre 5 e 120 (limites já apresentados no formulário) e escolaridade válida passam a existir no servidor. A faixa de idade não é apresentada como verificação de identidade ou prova de autorização.

### Aceites e histórico

Um registro de aceite conservará instante, revisão, versões e cópia dos documentos apresentados, gerados no servidor. A revisão exibida no formulário será conferida novamente no envio para evitar aceite de texto alterado durante a leitura. Contas existentes não receberão aceites na migração. Acesso ao perfil, exclusão, documentos e saída permanecerão disponíveis quando o aceite estiver pendente. O aceite dos termos e a ciência da política são distintos de consentimentos de tratamento ou autorização do responsável.

### Testes e dependências

Verificar em Minitest: rejeição de alterações sem senha, parâmetros proibidos, acesso restrito à conta autenticada, exclusão integral e isolamento dos demais participantes, encerramento de todas as sessões, jobs pendentes após exclusão e bloqueio e cadastro com campos opcionais. Em Capybara, cobrir o fluxo de edição e confirmação de exclusão com conta de teste. Nenhuma conta real será apagada durante a validação.

A definição do canal de atendimento, das bases legais e das retenções continua pendente. Autoatendimento não substitui todos os pedidos previstos em RF-015. Ranking e exportações continuam em avaliação quanto à exposição de menores, sem declaração de conformidade integral.

Padrões aplicáveis: `model-patterns`, `state-records`, `crud-patterns`, `migration-patterns`, `job-patterns`, `testing-patterns`, `rails-visual-design` e `rails-components`. Compatibilidade com a base existente: referências a users continuam bigint; o projeto não possui contas multi-tenant, portanto não será criado um account_id fictício. Novas entidades de aceite usarão UUID. A evolução acrescenta decisões à especificação existente, preservando o histórico do tópico 1.

Fontes consultadas: [LGPD](https://planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709compilado.htm), [ANPD sobre direitos e atendimento](https://www.gov.br/anpd/pt-br/assuntos/titular-de-dados/direito-dos-titulares), [ECA Digital](https://www.gov.br/anpd/pt-br/assuntos/eca-digital), [Enunciado 1/2023](https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-divulga-enunciado-sobre-o-tratamento-de-dados-pessoais-de-criancas-e-adolescentes/Enunciado1ANPD.pdf) e [Rails 8.1: locking e autenticação](https://api.rubyonrails.org/v8.1.3/classes/ActiveRecord/Locking/Pessimistic.html).


### Decisões finais desta rodada

A regra de autorização para todos os menores de 18 não foi aprovada. O usuário quer manter o cadastro aberto; a participação de menores e a exposição de nomes no ranking continuarão explicitamente pendentes de avaliação, sem novo bloqueio etário ou validação fictícia de responsáveis. A preferência por escola/presencial será retomada se a solução jurídica e de produto adotar esse procedimento. Não será criada tabela ou interface administrativa que finja uma verificação inexistente.

Os aceites usam `LegalDocument` (objeto de domínio para snapshot, versão e revisão SHA-256) e `LegalAcceptance` (registro UUID ligado ao user bigint existente). O snapshot contém os textos e metadados informados, sem dados adicionais de IP ou navegador. Campos do registro são readonly; revisão é única por usuário. `users.accepted_terms_at` começa nulo nas contas antigas. O cadastro público valida no contexto `registration`; contas de demonstração e provisionadas internamente podem existir sem manifestação e precisam passar pelo mesmo gate antes do jogo. A data e a revisão recebidas do navegador nunca substituem os valores do servidor.

`Users::LegalAcceptancesController#new/#create` oferece `/aceite/new` e `/aceite`, exige login e valida checkbox mais revisão apresentada. O gate fica em `Users::BaseController`; sessões, cadastro, perfil e o próprio aceite ficam dispensados. Jornada, ranking e todas as ações de jogo exigem aceite vigente. Uma mudança de texto provoca nova revisão; o texto permanece disponível na cópia de cada aceite anterior. Repetir o aceite não cria um novo horário para a mesma revisão. Links dos documentos abrem em nova aba, e a comunicação da atualização explica as pendências da minuta.

A versão 0.2 dos documentos descreve o perfil e a exclusão implementados, mantendo as pendências sobre responsáveis, contato, bases legais, retenções e cópias fora da aplicação ativa. O perfil mostra o histórico de versões e horários ao próprio titular. A edição requer senha atual; alteração de senha, estado de bloqueio e metadados jurídicos não são campos permitidos. A exclusão limpa apenas o contexto e o cookie do estudante; contas e cookies de administração não são apagados.


### Atualização: escola, consentimento e possibilidade de pesquisa futura

O usuário informou que o professor aplicará o Game QTA em escolas e que dados demográficos podem ser úteis futuramente à UESC, mas as análises ainda não estão definidas. A preferência atual é pelo caminho de consentimento do responsável quando aplicável. Isso atualiza o direcionamento pendente da tarefa 6.0, sem validar autorização geral ou um protocolo de pesquisa inexistente.

A implementação atual conserva os dados já informados e mantém cidade e escolaridade opcionais. Esta atualização de planejamento não altera a coleta, os schemas ou as permissões do produto. Tornar campos obrigatórios exige finalidade e necessidade concretas, além do enquadramento apropriado; o mesmo vale para novos prazos de guarda. Não reinterpretar os registros de `LegalAcceptance` como consentimento de pesquisa ou autorização parental.

Para o detalhamento da tarefa 6.0, separar: (a) funcionamento educativo e seus tratamentos necessários; (b) autorização do responsável quando aplicável; (c) pesquisa ou banco formal com propósito delimitado. Os três possuem efeitos distintos. Registrar finalidade, versão da informação apresentada, manifestação, papel de quem autorizou, forma de verificação, operador que a conferiu quando presencial e revogação; não recolher documentos de identificação como padrão indiscriminado. A verificação escolar depende do procedimento institucional e não substitui a manifestação do responsável pelo simples fato de o estudante estar matriculado.

Se o professor quiser constituir um banco para uso científico futuro, deverão ser definidos seu propósito, instituição responsável, categorias necessárias, acesso, segurança, guarda, hipóteses de uso futuro e autorizações pertinentes. A eventual dispensa de novo consentimento em estudos posteriores não será inferida pelo sistema; dependerá do enquadramento e das normas aplicáveis ao banco/estudo. Informações codificadas continuam sendo dados pessoais quando houver possibilidade de associação à pessoa; relatórios agregados também exigem avaliação do risco de reidentificação em turmas pequenas.

Sem essas definições, não habilitar exportação com o rótulo de pesquisa autorizada, não atribuir consentimento retroativo e não declarar a tarefa 6.0 concluída. O professor deverá confirmar os procedimentos de ética em pesquisa aplicáveis junto à instituição. A base jurídica do jogo e as obrigações do ECA Digital permanecem independentes da eventual autorização para pesquisa.

Fontes: [Guia ANPD para fins acadêmicos e pesquisas](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/web-guia-anpd-tratamento-de-dados-para-fins-academicos.pdf), [LGPD, arts. 6º, 8º e 14](https://www2.camara.leg.br/legin/fed/lei/2018/lei-13709-14-agosto-2018-787077-normaatualizada-pl.html), [Resolução CNS nº 738 sobre bancos de pesquisa](https://bvsms.saude.gov.br/bvs/saudelegis/cns/2025/res_0738_22_01_2025.html) e [orientação institucional sobre uso de bases de dados](https://www.cep.epsjv.fiocruz.br/orientacoes-protocolos/uso-de-base-de-dados). As referências não constituem aprovação de um estudo ou de consentimentos do projeto.

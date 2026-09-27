# Guia de Desenvolvimento & Padrões

Bem-vindo à equipe de engenharia do QTA. Adotamos rigidamente a filosofia **"The Rails Way"**. Nós favorecemos ferramentas nativas do ecossistema moderno do Rails em vez de soluções JavaScript complexas ou microserviços desnecessários.

## Stack Tecnológica Obrigatória
- **Linguagem & Framework:** Ruby 4.0.2 / Rails 8.1
- **Banco de Dados:** PostgreSQL
- **Frontend / Interatividade:** Hotwire (Turbo + Stimulus) e Tailwind CSS
- **Asset Pipeline:** Propshaft + Importmap (Proibido uso de Node.js, Webpack ou esbuild)
- **Background Jobs:** Solid Queue (backed pelo banco, não precisa de Redis)
- **Testes:** Minitest + Fixtures + Capybara (Não usamos RSpec nem FactoryBot)

## Arquitetura de Software
1. **Skinny Controllers, Rich Models:** A lógica de domínio (verificação de pontuação, bloqueio, transações) pertence aos Models. Serviços (`app/services/`) ou Action/UseCases **são desencorajados** a não ser em lógicas externas muito complexas. Use concerns horizontais (`Closeable`, `Assignable`).
2. **REST Estrito:** Controllers devem ter apenas as 7 ações REST. Se você precisa de uma ação diferente (ex: bloquear um usuário), crie um novo Controller focado naquele recurso (ex: `Users::BlocksController` ou actions explícitas em um controller dedicado usando PATCH).
3. **Sem JavaScript Inline:** Toda a interatividade front-end (modais, timers, validações customizadas front-end) DEVE viver em um controller do Stimulus (`app/javascript/controllers/`).

## Fluxo de Trabalho (Metodologia AI-SDD)

Para evitar que o sistema vire um "Frankenstein" ao longo dos meses, **nenhuma melhoria média ou grande vai direto para o código**. O trajeto de desenvolvimento é estritamente estruturado e visual.

Se você assumiu um item do Backlog, siga o trajeto abaixo:

1. **🌳 Branching:** Crie uma branch limpa para a sua feature (ex: `git checkout -b feature/feedback-pos-erro`).
2. **🧠 Planejamento (A Fase AI-SDD):** 
   - Crie uma nova pasta de requisitos: `/ai-sdd/prd-nome-da-feature/`.
   - Dentro dela, redija e aprove os 3 arquivos fundamentais:
     - `prd.md` (Como funciona a regra de negócio e experiência do usuário).
     - `techspec.md` (Quais migrações, models e rotas vão nascer/mudar).
     - `tasks.md` (Um checklist exato com a ordem técnica de execução).
3. **💻 Execução:** Programe seguindo estritamente as `tasks.md`.
4. **🧪 Validação:** Siga o Check-list abaixo antes de finalizar.

> **O motivo dessa burocracia:** Isso garante que daqui a dois anos, se um colega olhar para a coluna `explanation` na tabela `questions`, ele pode abrir o `/ai-sdd/` e entender todo o contexto histórico, aprovações e motivações que geraram aquela coluna.

## Check-list antes de abrir um PR (Pull Request)

Qualquer código submetido deve passar pelas seguintes etapas de validação sob pena de rejeição sumária:

1. **Linter Automático:** Rodar `bin/rubocop -a`. Nenhum *offense* pode sobrar.
2. **Testes de Unidade e Modelos:** Rodar `bin/rails test`.
3. **Testes de Sistema E2E:** Rodar `bin/rails test:system`. Isso testará as interações Turbo e Hotwire com Headless Chrome.
4. **Segurança e I18n:** Todas as strings voltadas para o usuário final devem usar `t('.key')` referenciando arquivos do `config/locales/`.

## Tratamento de Dados (Performance)
- **Evite o problema de N+1 queries:** Sempre que iterar coleções no banco, use `includes(:association)` ou queries agregadas como `.group(:id).count`.
- **Exportações Pesadas:** Nunca crie variáveis string gigantes na memória para baixar arquivos. Use sempre o `Enumerator` do Rails em conjunto com o `find_each` do ActiveRecord para realizar o *HTTP Streaming*.

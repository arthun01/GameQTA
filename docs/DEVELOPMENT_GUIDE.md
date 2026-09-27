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

## Check-list antes de abrir um PR (Pull Request)

Qualquer código submetido deve passar pelas seguintes etapas de validação sob pena de rejeição sumária:

1. **Linter Automático:** Rodar `bin/rubocop -a`. Nenhum *offense* pode sobrar.
2. **Testes de Unidade e Modelos:** Rodar `bin/rails test`.
3. **Testes de Sistema E2E:** Rodar `bin/rails test:system`. Isso testará as interações Turbo e Hotwire com Headless Chrome.
4. **Segurança e I18n:** Todas as strings voltadas para o usuário final devem usar `t('.key')` referenciando arquivos do `config/locales/`.

## Tratamento de Dados (Performance)
- **Evite o problema de N+1 queries:** Sempre que iterar coleções no banco, use `includes(:association)` ou queries agregadas como `.group(:id).count`.
- **Exportações Pesadas:** Nunca crie variáveis string gigantes na memória para baixar arquivos. Use sempre o `Enumerator` do Rails em conjunto com o `find_each` do ActiveRecord para realizar o *HTTP Streaming*.

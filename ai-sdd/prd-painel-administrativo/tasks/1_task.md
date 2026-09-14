# Tarefa 1.0: Setup do Projeto e Autenticação Administrativa

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Inicializar o projeto Rails 8 com a stack definida (PostgreSQL, Tailwind) e gerar a autenticação nativa direcionada ao modelo `Admin`. Esta é a base para o restante do painel.

## Requisitos Atendidos

- RF-001: Rota de login exclusiva, distinta da interface pública, validando administrador.
- RF-002: Restringir acesso às rotas do painel caso o admin não esteja autenticado.

## Conformidade com Standards

- **AGENTS.md**: Uso obrigatório do `bin/rails`. Tailwind CSS integrado via gems padrão. Minitest para testes (sem RSpec).
- **Tech Spec**: Autenticação deve usar o gerador nativo do Rails 8 (`bin/rails generate authentication Admin`).

## Subtarefas

- [x] 1.1 Rodar `rails new . -c tailwind -d postgresql -a propshaft --force` para inicializar a base no diretório atual (se não houver os arquivos base).
- [x] 1.2 Configurar `config/database.yml` e rodar `bin/rails db:create`.
- [x] 1.3 Rodar `bin/rails generate authentication Admin` para gerar a autenticação nativa.
- [x] 1.4 Mover os controllers gerados de sessão para o namespace `Admin::`.
- [x] 1.5 Atualizar o `config/routes.rb` para refletir as rotas de sessão sob o escopo ou namespace `admin`.

## Detalhes de Implementação

- **Referência**: Ver seção "Visão Geral dos Componentes" em `techspec.md`.
- **Pontos de atenção**: O gerador do Rails 8 cria os arquivos na raiz. Certifique-se de movê-los corretamente para `app/controllers/admin/` e ajustar a diretiva `require_authentication` num `Admin::BaseController` (que você deverá criar) para proteger as futuras rotas do painel.

## Critérios de Sucesso

- [x] Aplicação Rails roda sem erros.
- [x] Possível criar um registro de Admin pelo rails console.
- [x] Acessar `/admin/login` exibe a tela de login.
- [x] Tentar acessar um controller protegido sob `Admin::` redireciona para login.
- [x] Todos os testes gerados passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [x] Tentar acessar rota restrita sem login -> redireciona para login.
- [x] Login com credenciais corretas -> cria sessão e redireciona.

## Arquivos Relevantes

- `Gemfile` — Modificado — Setup do Tailwind/Propshaft
- `config/routes.rb` — Modificado — Rotas do namespace Admin
- `app/models/admin.rb` — Novo — Modelo gerado
- `app/controllers/admin/sessions_controller.rb` — Novo — Controlador de autenticação

## Dependências

—


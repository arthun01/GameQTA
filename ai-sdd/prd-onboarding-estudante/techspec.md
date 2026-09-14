# Tech Spec - Onboarding e Interface do Estudante

## Resumo Executivo

Esta especificação define a arquitetura para a Fase 2 (Onboarding do Estudante) do Game QTA. Implementaremos um novo modelo de autenticação segregado para `User` (o Estudante), usando o gerador nativo do Rails 8 para garantir segurança e independência do painel `Admin`.
O "Dashboard do Aluno" (Lobby/Mapa) será construído em um controller raiz dedicado à visão do estudante. A lógica de bloqueio de Níveis será calculada em tempo de execução via banco de dados (`Level.order(:created_at)` ou `:id`), evitando migrações complexas nesta fase do MVP. A interface seguirá um design pattern Mobile-first utilizando Tailwind CSS puro, conforme wireframes desenhados.

## Design de Referência

O design visual (UI/UX) foi previamente planejado e aprovado no arquivo: `ai-sdd/prd-onboarding-estudante/design.md`.
- Tela 1: Login do Estudante (Origem: Paper, ID: `5E-0`)
- Tela 2: Cadastro do Estudante (Origem: Paper, ID: `5F-0`)
- Tela 3: Dashboard de Níveis (Origem: Paper, ID: `5G-0`)
- Tela 4: Modal Nível Bloqueado (Origem: Paper, ID: `5H-0`)

As implementações de view (`.html.erb`) devem seguir estritamente o layout flexbox e o estilo Tailwind correspondente a estes artboards.

## Arquitetura do Sistema

### Visão Geral dos Componentes

- **`User` (Model)**: Responsável por armazenar as credenciais e dados demográficos do jogador.
- **`UserSession` (Model)**: Gerenciamento do token de sessão exclusivo do `User`.
- **`Users::BaseController` (Controller)**: Abstração que fará a proteção (Authentication) das rotas privadas do estudante, diferente do `Admin::BaseController`.
- **`Users::RegistrationsController` (Controller)**: Tratará o fluxo de criação de conta (RF-001, RF-002).
- **`Users::SessionsController` (Controller)**: Tratará o fluxo de login (RF-003).
- **`DashboardController` (Controller)**: O controlador principal pós-login, responsável por carregar a árvore de `Levels` e aplicar a lógica de bloqueios (RF-005 a RF-009).

## Design de Implementação

### Modelos de Dados

**Model: `User`**
```ruby
# users table
# - email_address: string, null: false, index: unique
# - password_digest: string, null: false
# - full_name: string, null: false
# - age: integer, null: false
# - city: string, null: false
# - education_level: integer, null: false

class User < ApplicationRecord
  has_secure_password
  has_many :user_sessions, dependent: :destroy

  enum :education_level, {
    fundamental_incompleto: 0,
    fundamental_completo: 1,
    medio_incompleto: 2,
    medio_completo: 3,
    tecnico: 4,
    superior_incompleto: 5,
    superior_completo: 6
  }

  validates :full_name, :age, :city, :education_level, presence: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
```

**Model: `UserSession`**
```ruby
# user_sessions table
# - user_id: references, null: false
# - ip_address: string
# - user_agent: string

class UserSession < ApplicationRecord
  belongs_to :user
end
```

### Endpoints / Rotas

As rotas da aplicação devem ser limpas e diretas para o estudante (ficarão no namespace global ou agrupadas, mas acessíveis de forma semântica):

| Método | Rota | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| GET/POST | `/cadastrar` | `users/registrations#new/create` | Cadastro de jogador (RF-001) |
| GET/POST | `/entrar` | `users/sessions#new/create` | Login de jogador (RF-003) |
| DELETE | `/sair` | `users/sessions#destroy` | Logout |
| GET | `/jornada` | `dashboard#index` | Mapa/Lobby (RF-005, RF-008) |

O `root to:` principal da aplicação (`/`) deve redirecionar para `/jornada` (que exigirá login e redirecionará para `/entrar` se não houver sessão ativa de User).

## Abordagem de Testes

### Testes Unitários
- **`User`**: Validar obrigatoriedade dos campos (full_name, age, city). Validar que o `education_level` aceita estritamente os enums mapeados.
- **`Level`**: Criar método `starting_level?` (verifica se é o `Level.order(:id).first`) para uso do Dashboard. Validar este método com testes de model.

### Testes de Integração
- **Controllers**: Confirmar que `DashboardController` não vaza caso o usuário não esteja logado.
- Confirmar que `Admin::SessionsController` não cria uma sessão que permita acessar `/jornada` (e vice-versa).

### Testes E2E (Capybara)
- **Fluxo de Onboarding Completo**: Visitar `/cadastrar`, preencher todos os campos (selecionando o nível de ensino), enviar o formulário e verificar se o sistema redirecionou para `/jornada` e exibe o "Nível 1" desbloqueado e o "Nível 2" bloqueado.

## Sequenciamento de Desenvolvimento

1. **Setup de Modelos (RF-001, RF-002)**: Gerar a migração do `User` e `UserSession`. Aplicar enums e validações.
2. **Setup de Autenticação (RF-003, RF-004)**: Criar os controllers `Users::SessionsController` e `Users::RegistrationsController`. Mapear rotas em português (`/entrar`, `/cadastrar`).
3. **Dashboard (Lógica de Bloqueio - RF-006, RF-007)**: Criar `DashboardController`. Implementar a query `Level.includes(:themes).order(:id)` e a lógica da view distinguindo o primeiro nível (`unlocked = true`) dos demais (`unlocked = false`).
4. **Implementação de UI/UX**: Transformar o HTML flexível gerado no Paper Desktop para as 4 views `.html.erb`, incluindo os modais e estados vazios/bloqueados.
5. **Polimento i18n**: Garantir que as chaves de tradução do form de estudante estejam mapeadas em `config/locales/pt-BR.yml`.

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas Rejeitadas |
|---------|---------|---------------|------------------------|
| Auth | 2 modelos independentes (`User` vs `Admin`) com sessions isoladas. | Permite que estudantes tenham dezenas de campos específicos na tabela de banco de dados sem poluir o modelo do Administrador, além de mitigar a zero as chances de um atacante invadir o painel de admin. | Single Table Inheritance (STI) com modelo `User` genérico. |
| Bloqueio do Nível 1 | Lógica via banco (`order(:id).first`). | Abordagem mais barata para MVP. Não requer interface adicional no painel de administração da Fase 1 para "Ativar Nível Inicial". | Adicionar um campo `is_start: boolean` em `Level`. |
| Layout Frontend | Criar `app/views/layouts/student.html.erb` | O layout de Admin contém uma sidebar, o estudante acessará via Mobile, necessitando um esqueleto HTML do topo à base dedicado. | Reaproveitar o `application.html.erb` usando lógicas `if admin_signed_in?`. |

### Riscos Conhecidos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------| 
| Conflitos de Helper de Autenticação (`Current.user` vs `Current.admin`) | Alta | Médio | Criar concerns explícitos `Users::Authentication` separados e não usar globals genéricos. |
| Nível 1 ser deletado e o jogo quebrar. | Baixa | Alto | A validação de Deleção (`restrict_with_error`) que criamos na Task 3 da Fase 1 já impede isso caso ele tenha Temas. |

### Conformidade com Standards do Projeto

- **AGENTS.md**: Utilização de `has_secure_password` e Rails 8 defaults (sem uso de Devise ou outras gems de auth).
- **Sem Service Objects**: A lógica de saber se um Nível é o inicial ou não viverá dentro de um método no model `Level`, e não num service de fora.
- **Frontend**: Zero dependência de frameworks Node. O Modal de nível bloqueado (Teaser) pode ser construído via HTML/CSS simples com classes utilitárias ou um micro controlador Stimulus se necessário (mas prefere-se CSS `<details>` ou states ocultos via toggle class).


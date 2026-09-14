# Tech Spec - Painel Administrativo (Gestão de Conteúdo)

## Resumo Executivo

A implementação do Painel Administrativo estruturará a base de dados central do jogo de Direito Ambiental. A abordagem utiliza as convenções nativas do Rails 8.1, aproveitando o gerador nativo de autenticação focado no modelo `Admin`. A modelagem de dados seguirá uma hierarquia estrita (`Level` -> `Theme` -> `Question` -> `Option`), com exclusões bloqueadas em cascata (`restrict_with_error`) para proteger a integridade pedagógica. A interface será conduzida via Hotwire (Turbo + Stimulus) e Tailwind CSS, incluindo formulários aninhados dinâmicos para o gerenciamento das opções de resposta.

## Design de Referência

O design visual foi aprovado e estruturado no Paper Desktop, focado em uma navegação Drill-down. Consulte o documento `ai-sdd/prd-painel-administrativo/design.md`.
- **Tela 1:** Dashboard de Níveis (Origem: Paper, ID: `1-0`)
- **Tela 2:** Lista de Temas (Origem: Paper, ID: `1A-0`)
- **Tela 3:** Lista de Questões (Origem: Paper, ID: `2C-0`)
- **Tela 4:** Formulário de Questão (Origem: Paper, ID: `3I-0`)

## Arquitetura do Sistema

### Visão Geral dos Componentes

- **Autenticação (Admin::SessionsController)**: Lida com login/logout exclusivo dos administradores. (Novo)
- **Modelos de Domínio**: `Level`, `Theme`, `Question`, `Option`. Responsáveis por abrigar todas as regras de validação (RF-12, presença de campos obrigatórios) e relacionamento. (Novos)
- **Controllers de Conteúdo**: `Admin::LevelsController`, `Admin::ThemesController`, `Admin::QuestionsController`. Finos e estritamente RESTful. (Novos)
- **Componentes Visuais (Views)**: Layout admin dedicado (`app/views/layouts/admin.html.erb`). Views ERB puras integradas com CSS Tailwind. Formulário da Questão usará um Stimulus Controller (`nested_form_controller.js`) para adição/remoção de opções no frontend.

## Design de Implementação

### Modelos de Dados e Migrações

- **Admin**
  - `email_address`: string, null: false, unique: true
  - `password_digest`: string, null: false
  - *Sessões serão criadas através do gerador do Rails 8.*

- **Level**
  - `name`: string, null: false
  - `description`: text, null: false
  - `icon`: string (para armazenar o emoji ou classe do ícone)
  - Relacionamento: `has_many :themes, dependent: :restrict_with_error`

- **Theme**
  - `name`: string, null: false
  - `description`: text, null: false
  - `icon`: string
  - `level_id`: references, null: false, foreign_key: true
  - Relacionamento: `has_many :questions, dependent: :restrict_with_error`
  - Relacionamento: `belongs_to :level`

- **Question**
  - `statement`: text, null: false
  - `youtube_link`: string, null: false
  - `feedback_article`: text, null: false
  - `difficulty`: integer, default: 0 (enum: `easy`, `medium`, `hard`)
  - `theme_id`: references, null: false, foreign_key: true
  - Relacionamento: `has_many :options, dependent: :destroy` (Aceita atributos aninhados: `accepts_nested_attributes_for :options, allow_destroy: true`)
  - Validação Customizada: Validar presença de 2 a 5 opções e exatamente 1 marcada como correta.

- **Option**
  - `content`: string, null: false
  - `is_correct`: boolean, default: false, null: false
  - `question_id`: references, null: false, foreign_key: true

### Endpoints / Rotas

| Método | Rota | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| GET/POST | `/admin/login` | `admin/sessions#new/create` | Autenticação (RF-001) |
| DELETE | `/admin/logout` | `admin/sessions#destroy` | Encerra sessão |
| GET/POST | `/admin/levels` | `admin/levels#index/create` | CRUD Níveis (RF-003) |
| GET/POST | `/admin/themes` | `admin/themes#index/create` | CRUD Temas (RF-005) |
| GET/POST | `/admin/questions`| `admin/questions#index/create` | CRUD Questões (RF-008) |

*(Nota: Rotas aninhadas rasas - shallow nesting - podem ser usadas para organizar a criação `level/1/themes/new` vs `themes/2/edit`).*

## Abordagem de Testes

### Testes Unitários (Minitest + Fixtures)
- **Modelos**: Foco absoluto nas validações customizadas do modelo `Question` (rejeitar salvamento se enviar opções sem `is_correct: true`, ou múltiplas opções corretas). Validar também o comportamento de `restrict_with_error` ao tentar deletar um Nível com Temas atrelados.

### Testes de Integração e E2E
- **Controllers**: Garantir que acesso a `/admin/*` redireciona para `/admin/login` se não autenticado.
- **Fluxos de Sistema (Capybara)**: Testar o preenchimento do formulário da Questão, clicando no botão "Adicionar Opção" (acionando o Stimulus) e salvando no banco.

## Sequenciamento de Desenvolvimento

1. **Setup e Infraestrutura**: Gerar aplicação Rails 8. Configurar banco PostgreSQL e Tailwind. Rodar gerador de autenticação para `Admin`.
2. **Camada de Base**: Criar Scaffold/Modelos e rotas para `Level` e `Theme`.
3. **Formulários Aninhados (O Complexo)**: Criar Modelos `Question` e `Option`. Implementar `accepts_nested_attributes_for` e o Stimulus `nested_form_controller`.
4. **Acabamento Visual**: Transpor o design aprovado do Paper para as views ERB, configurando o Layout Admin.

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas Rejeitadas |
|---------|---------|---------------|------------------------|
| Comportamento de Exclusão | `restrict_with_error` | Previne perda de dados massiva se o admin apagar um Nível sem querer. | `dependent: :destroy` (Muito arriscado para uma plataforma de ensino). |
| Criação de Opções | `accepts_nested_attributes` + Stimulus | Mantém a criação da Questão em uma única requisição e transação de banco. | Interface SPA complexa ou endpoints separados para criar opções, o que violaria o `AGENTS.md`. |
| Autenticação | Nativo Rails 8 (`bin/rails generate authentication`) | Código limpo, sem dependências externas, atualizado com a versão 8. | Gem Devise (pesada e desnecessária para um painel simples por ora). |

### Riscos Conhecidos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Vídeos do Youtube Inválidos | Média | Médio | Criar validação via Regex no modelo `Question` para aceitar apenas links válidos do YouTube. |
| Erros no Formulário Aninhado | Média | Alto | Garantir forte cobertura de testes de Sistema com Capybara interativo. |

### Conformidade com Standards do Projeto

- **AGENTS.md**: Totalmente aderente. A lógica de negócio ("garantir 1 opção correta") ficará no Model e não em Controllers ou Services. 
- **Sem JS Inline**: Toda interatividade do formulário aninhado ficará encapsulada no `app/javascript/controllers/nested_form_controller.js`.
- **i18n**: As validações personalizadas e mensagens de erro deverão ser extraídas para `config/locales/pt-BR.yml`.


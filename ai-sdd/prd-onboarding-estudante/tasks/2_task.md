# Tarefa 2.0: Autenticação e Telas de Acesso (Frontend + Controllers)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Construir o portal de entrada isolado dos administradores, com o layout Mobile-first aprovado, permitindo cadastro e login.

## Design de Referência
Ver `ai-sdd/prd-onboarding-estudante/design.md`. Telas desta task:
- #1 Login do Estudante — Origem: Paper — Ref: `5E-0`
- #2 Cadastro do Estudante — Origem: Paper — Ref: `5F-0`

## Requisitos Atendidos

- RF-001: Formulário completo de cadastro.
- RF-003: Login exclusivo de alunos.
- RF-004: Controle restritivo via sessão (`Users::BaseController`).

## Conformidade com Standards

- **AGENTS.md**: i18n para todos os textos. Nenhuma rota de `/admin` pode ser afetada.
- As views devem usar Tailwind CSS copiando as marcações do Paper Desktop via `paper-to-rails`.

## Subtarefas

- [ ] 2.1 Criar rotas `/entrar` e `/cadastrar` atreladas aos controllers correspondentes (`Users::SessionsController` e `Users::RegistrationsController`).
- [ ] 2.2 Criar um `Users::BaseController` que implemente a validação de sessão usando o `UserSession` (análogo à lógica nativa, mas para alunos).
- [ ] 2.3 Criar layout base `app/views/layouts/student.html.erb` (ou user) vazio de dependências corporativas (apenas links de assets do Rails e Tailwind base).
- [ ] 2.4 Transcrever e conectar o HTML do Paper `5F-0` (Cadastro) ao controller de `create`, atrelando o dropdown de níveis de ensino ao enum do modelo.
- [ ] 2.5 Transcrever e conectar o HTML do Paper `5E-0` (Login) ao controller de autenticação.

## Detalhes de Implementação

- **Referência**: Ver "Endpoints / Rotas" em `techspec.md`.
- **Pontos de atenção**: O Redirect após login bem sucedido ou cadastro deve apontar para `/jornada` (mesmo que a rota retorne erro no momento, será construída na Task 3).

## Critérios de Sucesso

- [ ] Um visitante anônimo acessa `/cadastrar` pelo navegador celular, vê o layout aprovado, preenche os dados e seu registro aparece no banco.
- [ ] A rota `/entrar` inicia uma nova `UserSession`.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes E2E (Capybara)
- [ ] `UserRegistrationTest`: Simular o preenchimento de todos os campos no formulário de `/cadastrar` e submeter.
- [ ] `UserLoginTest`: Simular acesso em `/entrar` com as credenciais criadas e verificar o cookie/auth válido.

## Arquivos Relevantes

- `config/routes.rb` — Modificado — Inclusão do novo namespace/rotas
- `app/controllers/users/base_controller.rb` — Novo
- `app/views/users/registrations/new.html.erb` — Novo
- `app/views/layouts/student.html.erb` — Novo

## Dependências

- Tarefa 1.0: Infraestrutura de Usuário


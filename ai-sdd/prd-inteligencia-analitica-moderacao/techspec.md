# Tech Spec - Inteligência Analítica & Moderação

## Resumo Executivo

A implementação da Fase 5 utiliza recursos nativos do Rails para entregar dashboards, exportação assíncrona eficiente e segurança de contas no painel administrativo. 
As decisões arquiteturais focam em: (1) utilização de HTTP Streaming via `Enumerator` e `find_each` para geração segura de CSVs sem sobrecarga de memória (OOM); e (2) uso do ecossistema de sessões baseadas no banco (`UserSession`) para invalidar acessos instantaneamente quando um estudante for bloqueado, sem necessitar de bibliotecas de terceiros como Devise.

## Design de Referência

A arquitetura visual que esta spec atende está documentada e aprovada em:
- `ai-sdd/prd-inteligencia-analitica-moderacao/design.md`
- Telas aprovadas (Origem: Texto):
  - 1. Dashboard Analítico
  - 2. Relatórios (Exportação)
  - 3. Listagem de Estudantes (Moderação)
  - 4. Gestão de Administradores

## Arquitetura do Sistema

### Visão Geral dos Componentes

- **`User` (Model)**: Adiciona lógica de status `blocked_at`, invalidação de sessões (`user_sessions.destroy_all`) e remoção do ranking associado. Modificado.
- **`Admin` (Model)**: Responsável por gerir as credenciais administrativas. Nenhuma alteração estrutural, já suporta `has_secure_password`.
- **`Users::SessionsController` (Controller)**: Impede novos logins de estudantes bloqueados. Modificado.
- **`Admin::DashboardsController` (Controller)**: Centraliza as queries SQL otimizadas (`count`) para os cards iniciais do Painel Admin. Modificado.
- **`Admin::ReportsController` (Controller)**: Novo componente. Gerencia o download via HTTP Streaming para os arquivos CSV. Novo.
- **`Admin::StudentsController` (Controller)**: Gerencia o CRUD de estudantes com o novo action `block` e exibição condicional do status. Modificado.
- **`Admin::AdminsController` (Controller)**: Novo CRUD. Permite criar e resetar a senha de outros administradores no painel. Novo.

## Design de Implementação

### Modelos de Dados

- **User**:
  - Nova migração: `AddBlockedAtToUsers`
  - Coluna: `blocked_at`, tipo: `datetime`, nulo: true.
  - Métodos novos: `block!`, `unblock!`, `blocked?`.

```ruby
# User Model extensions
def block!
  transaction do
    touch(:blocked_at)
    user_sessions.destroy_all
    leaderboard&.destroy
  end
end

def blocked?
  blocked_at.present?
end
```

### Interfaces Principais

```ruby
# CSV Streaming Controller Pattern
class Admin::ReportsController < Admin::BaseController
  def students
    headers.delete("Content-Length")
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = "attachment; filename=\"estudantes.csv\""
    headers["X-Accel-Buffering"] = "no"
    
    self.response_body = Enumerator.new do |yielder|
      yielder << CSV.generate_line(["Nome", "E-mail", "Pontuação", "Tempo Total"])
      User.find_each(batch_size: 1000) do |user|
        yielder << CSV.generate_line([user.full_name, user.email_address, user.leaderboard&.total_score, user.leaderboard&.total_time_taken])
      end
    end
  end
end
```

### Endpoints / Rotas

| Método | Rota | Controller#Action | Descrição | RF-PRD |
|--------|------|-------------------|-----------|--------|
| GET | `/admin/painel` | `Admin::Dashboards#show` | Cards consolidados | RF-001 |
| GET | `/admin/reports` | `Admin::Reports#index` | Botões de relatórios | RF-003, RF-005 |
| GET | `/admin/reports/students.csv` | `Admin::Reports#students` | Download CSV Estudantes | RF-004 |
| GET | `/admin/reports/themes.csv` | `Admin::Reports#themes` | Download CSV Temas | RF-006 |
| PATCH | `/admin/students/:id/block` | `Admin::Students#block` | Bloquear Aluno | RF-007, RF-008 |
| RESOURCES | `/admin/admins` | `Admin::AdminsController` | CRUD Equipe (Email/Senha) | RF-010 a RF-012 |

## Abordagem de Testes

### Testes Unitários
- **`UserTest`**: Valida que o método `block!` efetivamente destrói o `user_sessions` respectivo e exclui o `leaderboard`, garantindo atomicidade na transação.
- **Fixtures**: Criação de `blocked_user` com a data preenchida para testar restrições.

### Testes de Integração
- **`Users::SessionsControllerTest`**: Validar que autenticação com e-mail e senha válidos não gera sessão e exibe erro caso `blocked_at` seja presente (RF-008).
- **`Admin::ReportsControllerTest`**: Validar a resposta `200 OK` das rotas de exportação de CSV e que os cabeçalhos (`Content-Disposition`) estão corretos para download.

### Testes E2E (System Tests)
- **Moderação**: Logar como admin, buscar aluno, clicar em "Bloquear", aceitar alert e confirmar badge visual. Tentar logar com esse aluno no app e ver a mensagem de erro na tela de login.

## Sequenciamento de Desenvolvimento

### Ordem de Construção

1. **Migração e Model `User`**: Criação do `blocked_at` e métodos (RF-008, RF-009). Base para os testes.
2. **Controlador de Autenticação**: Bloqueio de login no frontend do aluno baseado na flag.
3. **Painel Admin - Dashboard & Estudantes**: Queries otimizadas no Dashboard (RF-001) e botão de bloqueio via Turbo em `Admin::StudentsController` (RF-007).
4. **Painel Admin - Admins**: CRUD para criação de novos super-usuários (RF-010 a RF-012).
5. **Módulo de Relatórios**: `Admin::ReportsController` com CSV HTTP Streaming (RF-003 a RF-006).

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas Rejeitadas |
|---------|---------|---------------|------------------------|
| Logout Remoto | Destruição da tabela `UserSession` no DB | Já temos controle próprio de sessões. Destruir os registros desloga todas as abas. | Invalidar senha ou alterar secret base. |
| CSV Generation | HTTP Streaming (`Enumerator`) | Não esgota a memória do servidor ao processar bases com 5.000+ linhas. | `send_data` em memória gerando array completo (falha de escalabilidade). |
| Deleção de Leaderboard | Remoção permanente | `Leaderboards` são reconstruídos via assíncrono. Bloquear apaga do ranking instantaneamente sem sujar as queries. | Flag de inatividade nas consultas de rank (causa degradação de query). |

### Conformidade com Standards do Projeto

- **AGENTS.md**: Respeita uso estrito de Hotwire (Turbo + Stimulus) para interatividade. Nenhuma biblioteca JS adicional; CSS com Tailwind puro.
- **Segurança**: Testes garantirão a proteção das rotas de `Admin::*` para não permitir acesso não autenticado (via concern existente de `Authentication`).

### Arquivos Relevantes e Dependentes

- `db/schema.rb` — Modificado (Nova migração e colunas)
- `app/models/user.rb` — Modificado
- `app/controllers/users/sessions_controller.rb` — Modificado
- `app/controllers/admin/dashboards_controller.rb` — Modificado
- `app/views/admin/students/index.html.erb` — Modificado
- `app/controllers/admin/reports_controller.rb` — Novo
- `app/controllers/admin/admins_controller.rb` — Novo
- `config/routes.rb` — Modificado (Novas rotas namespace `:admin`)

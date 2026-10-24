# Tarefa 4.0: Padronização Visual do Painel Administrativo & Ajustes nos Testes

**Objetivo:** Unificar a identidade visual do backoffice administrativo com o restante da aplicação, alinhando a barra lateral, cards de métricas, tabelas gerenciais e ajustando os testes de sistema.  
**Requisitos cobertos:** RF-012, RF-013  
**Responsável:** Ana Beatriz Guerra Mello  
**Status:** ✅ Concluído (Commit `39606c1`)

## Subtarefas Executadas

- [x] 4.1 **Sidebar Administrativa:** Refatoração de `app/views/admin/shared/_sidebar.html.erb` com badges modernas, estados ativos em tom emerald e ícones consistentes.
- [x] 4.2 **Dashboard Gerencial:** Estilização dos cards de métricas consolidadas em `app/views/admin/dashboards/show.html.erb`.
- [x] 4.3 **Tabelas de Gestão:** Padronização das visualizações de Níveis, Estudantes, Relatórios e Equipe de Administradores.
- [x] 4.4 **Ajuste em Testes E2E:** Atualização dos seletores e textos em `test/system/admin/admins_test.rb` para garantir 100% de cobertura e aprovação verde em `bin/rails test`.

## Arquivos Relacionados
- `app/views/admin/shared/_sidebar.html.erb`
- `app/views/admin/dashboards/show.html.erb`
- `app/views/admin/levels/index.html.erb`
- `app/views/admin/students/index.html.erb`
- `app/views/admin/admins/index.html.erb`
- `app/views/admin/reports/index.html.erb`
- `test/system/admin/admins_test.rb`

# Tarefa 4.0: Interface "Sua Jornada" (Níveis Desbloqueados/Concluídos, ODS e Avatar)

**Objetivo:** Atualizar a view `dashboard/index.html.erb` para destravar dinamicamente os níveis conforme `level.available_to?(Current.user)`, exibir status de nível/tema concluído, mapear imagens ODS pela posição sequencial e exibir a inicial real do estudante no cabeçalho.

**Requisitos cobertos:** RF-014, RF-015, RF-016

## Subtarefas

- [x] 4.1 **Desbloqueio na View (`dashboard/index.html.erb`):** Substituir `level.starting_level?` por `level.available_to?(Current.user)`, exibindo badge `"Concluído"` quando `level.passed_by?(Current.user)` e `"Em progresso"` caso contrário, além de indicar temas concluídos.
- [x] 4.2 **Helper `level_image_path`:** Mapear `ods-1.png` a `ods-5.png` pela posição sequencial do nível na trilha (1 a 5), evitando quebra quando os IDs do banco mudam.
- [x] 4.3 **Avatar Dinâmico:** Exibir a inicial de `Current.user.full_name` com link para `profile_path` nos cabeçalhos de `dashboard/index.html.erb` e `play/questions/show.html.erb`.
- [x] 4.4 **Teste E2E de Progressão:** Atualizar `test/system/progression_test.rb` verificando que, após concluir o Nível 1 com $\ge 70\%$, retornar à Jornada exibe o Nível 2 efetivamente desbloqueado.

## Arquivos Relacionados
- `app/views/dashboard/index.html.erb`
- `app/views/play/questions/show.html.erb`
- `app/helpers/application_helper.rb`
- `config/locales/pt-BR/accessibility.yml`
- `test/system/progression_test.rb`

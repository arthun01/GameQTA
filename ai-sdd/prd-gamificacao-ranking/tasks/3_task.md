# Tarefa 3.0: Motor de Visualização: Tela do Ranking

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Desenvolvimento da interface pública do Ranking que será visualizada pelos estudantes. Ela lista de forma limpa os Top 10 e traz o card de posição individual se o usuário logado estiver de fora.

## Requisitos Atendidos

- RF-005: Desempate por menor tempo.
- RF-006: Rota `/ranking` específica e visível.
- RF-007: Exibir os Top 10 na tabela.
- RF-008: Mostrar Posição, Nome e Pontuação no Top 10.
- RF-009: Exibir a mesma estrutura para o estudante atual de forma separada/em destaque, caso não esteja nos Top 10.

## Design de Referência
Ver `ai-sdd/prd-gamificacao-ranking/design.md`. Telas desta task:
- #1 Tela de Ranking — Origem: Paper — Ref: `BB-0`

## Conformidade com Standards

- **AGENTS.md**: Usa Tailwind CSS para componentes de medalha (sem frameworks CSS externos). Mantém o controller com ação estrita de leitura sem interatividade customizada JS, exceto onde requer Stimulus. Sem JS inline.

## Subtarefas

- [ ] 3.1 Declarar a rota `resources :rankings, only: [:index]` e criar o `RankingsController#index`.
- [ ] 3.2 Buscar a coleção do Top 10 via query simples: `.order(total_score: :desc, total_time_taken: :asc).limit(10)`.
- [ ] 3.3 Desenvolver a query/subquery para o aluno current_user identificando o `RANK()`/`DENSE_RANK() OVER (...)` daquele `user_id`, garantindo que ela não sofra impacto severo se existirem milhares de usuários.
- [ ] 3.4 Implementar a renderização da View (`index.html.erb`), extraindo partials para itens individuais (`_ranking_item.html.erb`).
- [ ] 3.5 Ajustar destaque visual (badge, cores) para as posições 1º, 2º e 3º.
- [ ] 3.6 Exibir a faixa fixa para a posição corrente do usuário.

## Detalhes de Implementação

- **Referência**: Ver seções "Controller" e "Decisões Principais" na TechSpec (especialmente recomendação sobre a Window Function SQL).
- **Pontos de atenção**: O uso do design do Paper garante que não seja preciso criar código de HTML/CSS pesado do absoluto zero. Apenas adeque as tags e as referências dinâmicas no ERB.

## Critérios de Sucesso

- [ ] Rota `/ranking` carrega mostrando até 10 usuários classificados, ou menos se não houver registros suficientes.
- [ ] Usuário que visita e está fora do top 10 vê o componente de "Sua Posição" indicando número exato (ex: 21º).
- [ ] Desempate no display exibe primeiramente aquele com menor tempo total.
- [ ] Layout responde bem em tela mobile conforme planejado.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [ ] RankingsControllerTest: Teste autenticado. Confirme se acessa `/ranking`. Se retornar 10 e se a ordem atende primeiramente score, e depois o tiebreak do tempo menor.

### Testes E2E
- [ ] System test `ranking_test.rb`: Navegue até a tela, confirme os dados carregando e validando se o badge especial do Top 1 existe.

## Arquivos Relevantes

- `config/routes.rb` — Modificado
- `app/controllers/rankings_controller.rb` — Novo
- `app/views/rankings/index.html.erb` — Novo
- `app/views/rankings/_ranking_item.html.erb` — Novo
- `test/controllers/rankings_controller_test.rb` — Novo
- `test/system/ranking_test.rb` — Novo

## Dependências

- Tarefa 2.0: Motor de Atualização Assíncrona (Job) — O banco precisa ter dados já validados para ser lido no controller.

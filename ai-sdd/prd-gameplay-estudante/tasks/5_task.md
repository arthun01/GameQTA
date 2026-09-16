# Tarefa 5.0: Progressão de Nível e Regra dos 70%

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Rotina de finalização do Tema. Se for o último do Nível, realiza a agregação de todas as notas do aluno para aquele Nível e aplica a restrição de reprovação com reset destrutivo ou aprovação para o próximo Nível.

## Design de Referência
Ver `ai-sdd/prd-gameplay-estudante/design.md`. Telas desta task:
- #4 Resultado do Nível — Origem: Paper — Ref: `9E-0`

## Requisitos Atendidos

- RF-008: Calcular progressão geral baseado nas respostas agrupadas do Nível.
- RF-009: Reiniciar progresso (limpar submissions) se não alcançar 70% e exigir refazer.
- RF-010: Exibir UI com desempenho e opção de prosseguir/recomeçar.

## Conformidade com Standards

- **AGENTS.md**: Lógica de reset em transaction de database para evitar falha parcial. Regra de negócio na classe de domínio (`Level` ou `ThemeAttempt`), e não no controller.

## Subtarefas

- [ ] 5.1 Adicionar Action `finish` no `Play::ThemesController` que verifica se era o último tema do nível.
- [ ] 5.2 Se for o último: criar método no Model para juntar todos os `ThemeAttempt` e `QuestionSubmission` daquele Level.
- [ ] 5.3 Se total_score >= 70%: Renderiza view Sucesso (Referência `9E-0`) que libera próximo nível.
- [ ] 5.4 Se total_score < 70%: Realiza a deleção `ThemeAttempt.where(user: user, theme: level.themes).destroy_all`. Renderiza view Falha.
- [ ] 5.5 View Result para exibir a barra de % de acertos.

## Detalhes de Implementação

- **Referência**: Ver "Design de Implementação" na `techspec.md`.
- **Pontos de atenção**: O cálculo usa inteiros/floats. (acertos / total) * 100. Cuidado com divisões por zero se por acaso um Nível não tiver questões.

## Critérios de Sucesso

- [ ] Acessar um Nível com < 70% ao final resulta em exclusão silenciosa dos logs e reinício limpo se o aluno voltar ao painel.
- [ ] UI de resultado implementada com fiel representação do progresso (0 a 100%).
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [ ] Completar a última questão que resulta em < 70% apaga `ThemeAttempts` da base.
- [ ] Completar a última questão com > 70% mantém os records e renderiza UI de vitória.

## Arquivos Relevantes

- `app/controllers/play/themes_controller.rb` — Modificado
- `app/models/theme_attempt.rb` — Modificado
- `app/views/play/themes/finish.html.erb` — Novo

## Dependências

- Tarefa 4.0: Submissão, Validação e Feedback


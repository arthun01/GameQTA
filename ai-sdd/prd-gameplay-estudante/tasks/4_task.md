# Tarefa 4.0: Submissão, Validação e Feedback

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Processamento do POST do form das alternativas. Envolve a lógica crítica anti-cheat calculando o tempo no servidor e determinando o próximo passo (próxima questão ou modal de erro).

## Design de Referência
Ver `ai-sdd/prd-gameplay-estudante/design.md`. Telas desta task:
- #3 Modal de Feedback de Erro — Origem: Paper — Ref: `9D-0`

## Requisitos Atendidos

- RF-004: Validar opção e gravar tentativa.
- RF-005: Interromper a questão em caso de erro, com popup (modal) contendo artigo explicativo.
- RF-006: Fechar modal recarrega para a próxima questão do Tema.
- RF-007: Se o erro ocorrer na última questão, segue para Nível Concluído.

## Conformidade com Standards

- **turbo-patterns**: Devolver um modal HTML acoplado ao body via `turbo_stream.append` ou atualizar o frame caso esteja correto.

## Subtarefas

- [x] 4.1 Adicionar action `submit` ao `Play::QuestionsController`.
- [x] 4.2 Lógica no Model (ou no controller) que avalia `Time.current - revealed_at`. Se exceder o `GameSetting` da dificuldade (com 2s de margem), computa como erro.
- [x] 4.3 Se correto: salva `QuestionSubmission`, redireciona pro `show` (próxima pergunta) ou `themes_controller#finish` (se última).
- [x] 4.4 Se incorreto: salva `QuestionSubmission`, renderiza view Turbo Stream que abre o Modal e mostra o artigo explicativo (referência `9D-0`).
- [x] 4.5 Botão "Próxima Questão" do Modal faz redirect para a próxima.

## Detalhes de Implementação

- **Referência**: Ver "Riscos Conhecidos" e segurança na `techspec.md`.
- **Pontos de atenção**: O modal precisa estar acima de todo o conteúdo e bloquear interações indesejadas (z-index adequado).

## Critérios de Sucesso

- [x] Errar invoca um Turbo Stream que exibe imediatamente o design de falha.
- [x] Acertar vai para a próxima tela sem travamentos.
- [x] Hacks simulados no relógio do client são identificados pelo cálculo de `revealed_at`.
- [x] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes de Integração
- [x] Submissão no tempo correto com opção certa redireciona pro `show` com sucesso.
- [x] Submissão com tempo estourado (simulado em teste) marca como errado e devolve Turbo stream pro modal.
- [x] Submissão de opção errada retorna Turbo stream pro modal.

## Arquivos Relevantes

- `app/controllers/play/questions_controller.rb` — Modificado
- `app/views/play/questions/submit.turbo_stream.erb` — Novo
- `app/views/play/questions/_feedback_modal.html.erb` — Novo

## Dependências

- Tarefa 3.0: Dinâmica de Revelação e Cronômetro


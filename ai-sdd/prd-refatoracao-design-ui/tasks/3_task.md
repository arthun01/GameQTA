# Tarefa 3.0: Interface de Gameplay e Rodapé Institucional (TekohaLab / UESC)

**Objetivo:** Modernizar a tela de resolução de desafios e perguntas (`Play::QuestionsController`), refinando os cartões de alternativas, modais de avaliação e incluindo créditos formais ao TekohaLab e à UESC.  
**Requisitos cobertos:** RF-009, RF-010, RF-011  
**Responsável:** Ana Beatriz Guerra Mello  
**Status:** ✅ Concluído (Commit `3fc9ac0`)

## Subtarefas Executadas

- [x] 3.1 **Layout de Resolução:** Atualização de `app/views/play/questions/show.html.erb` com melhor hierarquia visual para o vídeo, timer e opções de resposta.
- [x] 3.2 **Feedback & Avaliação:** Refatoração de `app/views/play/questions/_evaluation.html.erb` com cartões de resultado estilizados e feedback pedagógico claro.
- [x] 3.3 **Créditos Institucionais:** Adição do asset `public/tekohalab.png` e integração do rodapé com assinatura do laboratório e da universidade na experiência de jogo.

## Arquivos Relacionados
- `app/views/play/questions/show.html.erb`
- `app/views/play/questions/_evaluation.html.erb`
- `public/tekohalab.png` (Novo)

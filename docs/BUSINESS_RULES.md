# Regras de Negócio & Escopo

Este documento centraliza as lógicas vitais do Game QTA. Antes de alterar controllers ou models, certifique-se de que as mudanças não quebram essas premissas estruturais.

## 1. Gamificação e Pontuação
O sistema de jogo é baseado no acúmulo de pontos condicionado ao tempo e à precisão.
*   **Fácil:** 10 pontos.
*   **Médio:** 20 pontos.
*   **Difícil:** 30 pontos.
*   *Condição:* Pontos **só são atribuídos se a resposta estiver correta**. Se o usuário errar, ganha 0 pontos.

## 2. Ranking Global (Leaderboard)
O Leaderboard define quem são os melhores alunos da plataforma.
*   **Classificação Primária:** Maior `total_score` (Soma de pontos).
*   **Desempate (Tie-breaker):** Menor `total_time_taken` (Soma total dos tempos gastos nas questões submetidas).
*   **Performance:** A atualização do ranking de um usuário ocorre **assincronamente via Background Job** (`UpdateUserJob`) assim que ele responde a uma questão, prevenindo lentidão na interface (UX).

## 3. Progressão de Nível e Temas (Regra dos 70%)
O aluno não pode avançar livremente pelos níveis. Existe um fluxo de validação de conhecimento.
*   Um **Tema** possui várias questões. O estudante joga um tema por vez (`ThemeAttempt`).
*   **Aprovação:** Para liberar o próximo Nível, o aluno precisa concluir todos os Temas e acertar **70% ou mais de todas as questões exigidas desse Nível**, conforme RF-008 a RF-010 do PRD de gameplay. Questões omitidas entram no denominador. Uma tentativa só é concluída após todas as questões serem respondidas ou encerradas por tempo.
*   **Reprovação:** Abaixo de 70% no Nível completo, o progresso desse Nível é reiniciado em transação, incluindo tentativas e respostas. O ranking é recalculado após o commit. A aprovação usa a proporção exata; o percentual exibido pode ser arredondado.

## 4. Estrutura Educacional (Conteúdo)
*   **Hierarquia Rígida:** Nível (Level) ➔ Tema (Theme) ➔ Questão (Question) ➔ Opção (Option).
*   **Regra de Ouro da Questão:** É bloqueado a nível de modelo e banco de dados criar uma questão que não tenha **exatamente 1 opção correta**. Não pode ter zero corretas, nem mais de uma correta.

## 5. Moderação e Punição (Anti-Cheat & Bans)
O sistema tem tolerância zero para manipulação ou violação de regras.
*   **Anti-Cheat de Tempo:** Embora o cronômetro visual rode no navegador (JS/Stimulus), o backend checa a variação real de tempo (`revealed_at` vs. `submitted_at`) para evitar adulteração na pontuação de desempate.
*   **Banimento Atômico:** Quando um aluno é bloqueado pelo admin (`block!`), o sistema dispara uma transação que:
    1. Marca `blocked_at`.
    2. Encerra imediatamente todas as sessões ativas (Deslogando o aluno se ele estiver online).
    3. Apaga o registro do aluno do Ranking (Deleta o registro `Leaderboard`), retirando-o do pódio público instantaneamente.


## 6. Aceite, perfil e exclusão (governança em andamento)

- O cadastro público valida o aceite dos Termos e a ciência da Política no servidor, vinculando uma revisão e cópia dos documentos. Não tratar esse registro como consentimento geral ou autorização de responsável.
- Contas existentes não recebem aceites retroativos. Sem manifestação atual, o jogo e o ranking redirecionam para a tela de documentos; perfil, exclusão, leitura pública e saída continuam disponíveis.
- Cidade e escolaridade são opcionais. Não solicitar dados adicionais excessivos no cadastro geral.
- Atualização do perfil exige senha atual e somente campos permitidos. Estado de bloqueio, senha e metadados de aceite não podem ser alterados por esse formulário.
- A exclusão exige senha e confirmação explícita, age exclusivamente sobre `Current.user` e remove os dados relacionados em transação. Todas as sessões do estudante são encerradas; outros usuários e o conteúdo didático são preservados.
- Atualizações de ranking usam lock da conta, em comum com exclusão e bloqueio. Conta ausente ou bloqueada não recebe novo ranking.
- A operação segue cadastro direto sem nova aprovação externa, com idade, escolaridade e cidade preservadas. Ranking usa código automático; contato público informado: Guilhardes de Jesus Júnior, guilhardesj@gmail.com. Bases legais, medidas de proteção/supervisão, retenções e cópias exportadas continuam em avaliação. A entrega parcial não declara adequação integral à LGPD.


## Vídeos, tempo e acessibilidade

Vídeos externos ficam desligados até a escolha Carregar este vídeo. É possível continuar sem vídeo ou desativá-lo depois; essa escolha não é salva para outras páginas. Antes de revelar cada questão, qualquer pessoa pode escolher de 1 a 10 vezes o tempo padrão. A seleção não exige diagnóstico. O limite é definido no servidor e não reinicia ao recarregar. Pontos por acerto não mudam; o tempo efetivo continua no desempate. Selecione a alternativa e use Confirmar resposta; o envio não ocorre só pela seleção. Uma resposta encerrada por tempo esgotado não reabre a mesma questão.

O acesso expira 12 horas após login; dados e progresso da conta são preservados. A página /acessibilidade explica teclado, controles e limitações. Não há declaração de equivalência audiovisual ou conformidade integral antes da avaliação editorial e humana.

### Integridade da conclusão e do ranking

A conclusão ocorre por POST; consultar resultado por GET não altera tentativas. Repetir o início retoma a tentativa ativa e preserva respostas. Início e conclusão são serializados por estudante. Níveis são liberados segundo os anteriores na ordem de ID. No ranking, pontuação e tempo iguais compartilham posição (DENSE_RANK); ID do usuário estabiliza apenas a ordem de exibição entre empatados. Quem não aparece nas dez linhas recebe cartão pessoal, mesmo com posição empatada menor que dez. O acúmulo de pontos de repetições mantém o comportamento existente, sem nova política nesta correção.

Durante uma repetição em andamento, a conclusão anterior do tema continua valendo para liberar níveis posteriores. Quando a nova tentativa é concluída, seu resultado substitui o anterior na avaliação do nível; se reprovar, aplica-se o reset existente. A resposta grava os pontos atribuídos naquele momento. O recálculo agregado mantém o comportamento existente de usar respostas e dificuldades atuais, sincronizando `users.total_score` e o ranking. Ao desbloquear uma conta, sua classificação é recomposta na mesma operação a partir das respostas preservadas.

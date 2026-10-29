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
*   **Aprovação:** Para ser aprovado em um Tema e desbloquear o próximo, o aluno precisa acertar **70% ou mais** das questões daquele tema específico.
*   **Reprovação:** Se a taxa de acerto for menor que 70%, a tentativa falha. O banco de dados **apaga atômica e integralmente** aquela submissão em transação (`QuestionSubmission`), obrigando o estudante a repassar pelo conteúdo do tema para fixação de aprendizado.

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
- Autorizações por faixa etária, bases legais, contato público, retenções e cópias exportadas seguem pendentes. A entrega parcial não declara adequação integral à LGPD.

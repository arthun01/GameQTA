# Backlog Estratégico & Melhorias (Pós-MVP)

Este documento atua como o repositório central de ideias, melhorias contínuas e *features* futuras para o Game QTA. 

O objetivo aqui não é detalhar a parte técnica imediatamente, mas sim **registrar estrategicamente o "O quê" e o "Por quê"**. Quando decidirmos atacar uma dessas ideias, ela será extraída daqui para gerar um PRD completo (usando a metodologia AI-SDD) e entrará na esteira de desenvolvimento.

---

## 🎮 Game Design & Engajamento (Gamificação Avançada)
*Melhorias focadas em retenção de alunos e dinâmica de jogo.*

- [ ] **Sistema de Vidas / Energia:** Limitar a quantidade de vezes que o aluno pode errar no dia, adicionando uma mecânica de recarga (ex: corações).
- [ ] **Streak Diário (Ofensiva):** Recompensar alunos que entram e jogam todos os dias consecutivos (estilo Duolingo).


## 📚 Conteúdo & Educação
*Melhorias focadas no processo de aprendizagem.*

- [ ] **Feedback Detalhado Pós-Erro:** Atualmente, a tela de erro é seca. Adicionar uma "Explicação do Professor" exibindo por que a alternativa escolhida estava errada.
- [ ] **Dicas (Hints) Compráveis:** Opção de "Gastar 10 pontos do ranking para eliminar 2 opções incorretas" (Mecânica "50/50").


## 🛡️ Administração & Analytics
*Melhorias para o Backoffice e Gestores.*

- [ ] **Gráficos Visuais no Dashboard:** Substituir os números brutos por gráficos em linha/barra (Chart.js ou ApexCharts) mostrando o crescimento de acessos ao longo do mês.
- [ ] **Trilhas de Auditoria (Logs):** Registrar qual Admin baniu qual estudante e qual Admin criou/editou qual Questão (rastreabilidade).
- [ ] **Importação em Lote:** Permitir que o Admin faça upload de um `.csv` com 50 questões prontas para popular o banco de dados magicamente, em vez de digitar uma por uma.

## ⚙️ Técnico, UX & Infraestrutura
*Melhorias invisíveis ou de conforto visual.*

- [ ] **Dark Mode (Modo Escuro):** Alternância visual entre claro/escuro via Tailwind.
- [ ] **Animações (Micro-interações):** Adicionar confetes caindo na tela de ranking ou animações Lottie de celebração ao passar de nível.
- [ ] **Suporte a PWA (Progressive Web App):** Fazer o sistema ser instalável no celular como um app nativo, com ícone na tela inicial.

---

## 📝 Como registrar uma nova ideia?

Para adicionar algo novo a este Backlog, use o formato:
> **[Nome da Feature]**: Breve explicação de 1 ou 2 linhas sobre o valor que isso gera para o sistema ou para o usuário.

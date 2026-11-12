# Tarefas de Implementação - Correções Críticas de Progressão, Segurança de Gameplay e Estabilidade

## Referências

- **PRD**: [prd.md](prd.md)
- **Tech Spec**: [techspec.md](techspec.md)
- **Design**: [design.md](design.md)

## Resumo

As correções identificadas na auditoria e no teste prático de progressão foram organizadas em **5 tarefas atômicas e sequenciais**, cobrindo desde o desbloqueio real de níveis na regra de 70% e a blindagem do backend até a sincronização do ranking, validações do painel administrativo e higienização de código/testes.

- **Total de tarefas**: 5
- **Requisitos cobertos**: RF-001 a RF-017

## Tarefas

| # | Tarefa | Arquivo | Requisitos | Deps | Status |
|---|--------|---------|------------|------|:------:|
| **1.0** | Motor de Desbloqueio Real de Níveis, Progressão e Proteção Backend | [tasks/1_task.md](tasks/1_task.md) | RF-001 a RF-007 | — | ✅ |
| **2.0** | Sincronização do Ranking (`Leaderboard`) em Resets e Pontuações | [tasks/2_task.md](tasks/2_task.md) | RF-008, RF-009 | 1.0 | ✅ |
| **3.0** | Validações do Model `Admin`, Painel Admin e Proteção CSV Injection | [tasks/3_task.md](tasks/3_task.md) | RF-010 a RF-013 | — | ✅ |
| **4.0** | Interface "Sua Jornada" (Níveis Desbloqueados/Concluídos, ODS e Avatar) | [tasks/4_task.md](tasks/4_task.md) | RF-014 a RF-016 | 1.0 | ✅ |
| **5.0** | Higienização do Repositório, I18n, Padronização Admin e Testes E2E | [tasks/5_task.md](tasks/5_task.md) | RF-017 | 1.0–4.0 | ✅ |

**Legenda**: ⬜ Pendente · 🔄 Em andamento · ✅ Concluída

## Ordem de Execução

```text
1.0 → 2.0 → 3.0 → 4.0 → 5.0
```

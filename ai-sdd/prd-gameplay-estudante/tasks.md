# Tarefas de Implementação - Motor de Gameplay e Progressão do Estudante

## Referências

- **PRD**: `prd.md`
- **Tech Spec**: `techspec.md`
- **Design**: `design.md`

## Resumo

O motor de gameplay foi decomposto em 5 entregáveis lógicos, começando da fundação de dados (`ThemeAttempt` e submissões), passando pela infraestrutura base de controller, integrando o frontend reativo (Hotwire + Stimulus) para a resposta da questão com proteção contra cheats de tempo, e finalizando no cálculo global de progressão.

- **Total de tarefas**: 5
- **Requisitos cobertos**: RF-001 a RF-010

## Tarefas

| # | Tarefa | Arquivo | Deps | Status |
|---|--------|---------|------|--------|
| 1.0 | Infraestrutura de Dados (Modelagem e Settings) | [tasks/1_task.md](tasks/1_task.md) | — | ✅ |
| 2.0 | Motor de Inicialização e Tela de Consumo | [tasks/2_task.md](tasks/2_task.md) | 1.0 | ✅ |
| 3.0 | Dinâmica de Revelação e Cronômetro | [tasks/3_task.md](tasks/3_task.md) | 2.0 | ✅ |
| 4.0 | Submissão, Validação e Feedback | [tasks/4_task.md](tasks/4_task.md) | 3.0 | ✅ |
| 5.0 | Progressão de Nível e Regra dos 70% | [tasks/5_task.md](tasks/5_task.md) | 4.0 | ✅ |

**Legenda**: ⬜ Pendente · 🔄 Em andamento · ✅ Concluída

## Ordem de Execução

```text
1.0 → 2.0 → 3.0 → 4.0 → 5.0
```


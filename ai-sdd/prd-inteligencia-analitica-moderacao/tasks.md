# Lista de Tarefas - Inteligência Analítica & Moderação

## Tarefas Principais

| ID | Tarefa | Requisitos | Complexidade |
|----|--------|------------|--------------|
| **1.0** | Fundação da Moderação (Model User) | RF-008, RF-009 | Baixa |
| **2.0** | Dashboard e Interface de Moderação de Alunos | RF-001, RF-002, RF-007 | Média |
| **3.0** | Módulo de Relatórios e Exportação CSV | RF-003 a RF-006 | Média |
| **4.0** | CRUD de Equipe (Gestão de Administradores) | RF-010 a RF-012 | Baixa |

## Dependências
- Tarefa 1.0 é o alicerce absoluto, provendo a flag e os métodos necessários para que o `Admin::StudentsController` funcione na Tarefa 2.0.
- A Tarefa 3.0 e 4.0 não possuem bloqueios técnicos entre si.

## Instruções de Execução
Para implementar uma tarefa, use a skill `executa-task` passando o caminho do arquivo da tarefa.
Exemplo: `Ative a skill executa-task para ai-sdd/prd-inteligencia-analitica-moderacao/tasks/1_task.md`

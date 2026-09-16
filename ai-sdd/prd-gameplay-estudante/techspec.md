# Tech Spec - Motor de Gameplay e Progressão do Estudante

## Resumo Executivo
Esta especificação técnica detalha a implementação da Fase 3 do projeto Game QTA, cobrindo o core loop de gameplay. O foco arquitetural é um modelo anti-trapaça onde a contagem de tempo e validação de 70% residem no servidor. Usaremos Stimulus para a contagem visual decrescente e Turbo para trocas de estado (revelar questão, mostrar popup de erro, avançar), mantendo as páginas rápidas sem recarregamento (SPA-like feel) e obedecendo a arquitetura "The Rails Way" definida no `AGENTS.md`.

## Design de Referência
O design visual da funcionalidade foi aprovado e documentado em `ai-sdd/prd-gameplay-estudante/design.md`.
As seguintes telas devem ser implementadas usando Tailwind CSS e Flexbox conforme artboards gerados no Paper Desktop:
- `9B-0` — gameplay-estudante / Desafio - Passo 1: Consumo / mobile
- `9C-0` — gameplay-estudante / Desafio - Passo 2: Avaliação / mobile
- `9D-0` — gameplay-estudante / Modal de Feedback de Erro / mobile
- `9E-0` — gameplay-estudante / Resultado do Nível / mobile

## Arquitetura do Sistema

### Visão Geral dos Componentes
- **`ThemeAttempt` Model**: (Novo) Armazena a sessão de jogo do usuário para um determinado Tema.
- **`QuestionSubmission` Model**: (Novo) Registra cada tentativa de resposta, tempo levado e acerto/erro.
- **`GameSetting` Model**: (Novo) Armazena configurações globais de tempo por dificuldade.
- **`Play::ThemesController`**: (Novo) Gerencia o início do tema e transições.
- **`Play::QuestionsController`**: (Novo) Gerencia a exibição do vídeo (Consumo), revelação da questão (Avaliação) e submissão (Feedback).
- **`GameplayTimer` Stimulus Controller**: (Novo) Exibe a contagem decrescente na UI baseada na tolerância enviada pelo servidor, disparando submissão automática via Turbo caso o tempo expire.

## Design de Implementação

### Modelos de Dados

- **Entidades de Domínio**:

```ruby
# ThemeAttempt
# - status: enum (in_progress: 0, completed: 1)
#
# relationships
# - belongs_to :user
# - belongs_to :theme
# - has_many :question_submissions, dependent: :destroy
#
# indexes
# - [:user_id, :theme_id]

# QuestionSubmission
# - is_correct: boolean, default: false
# - revealed_at: datetime
# - time_taken: integer (em segundos)
#
# relationships
# - belongs_to :theme_attempt
# - belongs_to :question
# - belongs_to :option, optional: true
#
# validations
# - question_id scoped to theme_attempt_id uniqueness (apenas 1 resposta por tentativa)

# GameSetting
# - easy_time: integer, default: 60
# - medium_time: integer, default: 45
# - hard_time: integer, default: 30
# (Usaremos um padrão Singleton ou acesso de classe genérico)
```

### Endpoints / Rotas

| Método | Rota | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| POST | `/play/themes/:id/start` | `play/themes#start` | Cria `ThemeAttempt` (cancela in_progress anteriores) e redireciona |
| GET | `/play/theme_attempts/:id/question` | `play/questions#show` | Mostra a questão atual (Vídeo + Botão Mostrar Questão) |
| POST | `/play/theme_attempts/:id/question/reveal`| `play/questions#reveal` | Turbo Stream que salva `revealed_at` e mostra as opções |
| POST | `/play/theme_attempts/:id/question/submit`| `play/questions#submit` | Valida tempo, verifica resposta e mostra modal ou avança |

## Abordagem de Testes

### Testes Unitários
- **Modelos**: 
  - `ThemeAttempt`: Escopos para recuperar a tentativa ativa. Regras para calcular a porcentagem do Nível ao finalizar.
  - `QuestionSubmission`: Testar a lógica customizada de cálculo de tempo em model callbacks ou num concern.
- **Integração de Modelos**: 
  - Validar a lógica de reset de Nível: criação de temas pendentes, cálculo de 70% e se as tentativas antigas do Nível são destruídas se a média não for atingida.

### Testes E2E (System Tests)
- **Fluxos Principais**: 
  - Usuário clica em "Mostrar Questão", cronômetro renderiza via JS, clica numa opção, avança.
- **Casos Extremos**: 
  - Usuário espera o relógio zerar (deve acionar submissão automática com erro).
  - Tentativa de enviar opção após manipular o clock local (deve ser rejeitada pelo backend baseado no `revealed_at`).

## Sequenciamento de Desenvolvimento

1. **Modelagem de Dados**: Migrations, models `ThemeAttempt`, `QuestionSubmission` e `GameSetting` com fixtures iniciais (RF-008, RF-010).
2. **Setup do Fluxo Play**: Rotas e controllers base (`Play::ThemesController` e `Play::QuestionsController`).
3. **Frontend Interativo (Hotwire)**: Views, integração Turbo Streams para `reveal` e `submit`, e o Stimulus controller do cronômetro (RF-001, RF-002, RF-003).
4. **Mecânica de Feedback e Validação de Tempo**: Modal de erro sobreposto e proteção de timestamps (RF-005, RF-006, RF-007).
5. **Cálculo de Progressão**: Rotina de verificação de 70% no fim do último Tema de um Nível para reset ou avanço (RF-009, RF-010).

## Considerações Técnicas

### Decisões Principais

| Decisão | Escolha | Justificativa | Alternativas Rejeitadas |
|---------|---------|---------------|------------------------|
| Segurança de Tempo | Server-side Timestamp | Usar JS seria muito vulnerável a hackers modificando a UI. | Client-side tracking via JS hidden inputs. |
| Granularidade do Jogo | `ThemeAttempt` | O aluno precisa poder pausar o Nível no meio e continuar dias depois de onde parou (Tema por Tema). | Um único enorme `LevelAttempt` que resetaria horas de progresso se ele fechasse o navegador. |
| Interatividade UI | Turbo Streams | Preserva a filosofia *Rails Way*, trocando estados sem React/Vue. | Full SPA ou jQuery. |

### Riscos Conhecidos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------| 
| Timeout Network | Média | Médio | Se a requisição de resposta atrasar, o servidor pode achar que o aluno estourou o tempo. O servidor terá 2-3 segundos de tolerância de carência no tempo limite. |
| Abandono de Jogo | Alta | Baixo | Acúmulo de `ThemeAttempt` pendentes (`in_progress`). Cleanup ao iniciar nova tentativa resolverá a sujeira. |

### Conformidade com Standards do Projeto
- **`model-patterns`**: Evita models muito gordos usando concerns, mas neste escopo pequeno, as responsabilidades de progressão ficarão nos próprios models de Attempt. Sem `app/services` conforme a regra rígida do projeto.
- **`turbo-patterns`**: Uso de Turbo Frames/Streams no formulário de questão, mantendo o usuário na página e abrindo popups inline.
- **`AGENTS.md`**: Controllers *thin*, restritos a ações REST e lógica de negócios focada no modelo. Testes puramente em Minitest/Fixtures. Sem RSpec ou FactoryBot.


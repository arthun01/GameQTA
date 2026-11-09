# Design Specification - Correções de Progressão, UI da Jornada e Padronização Admin

## 1. Estados Visuais dos Níveis na Tela "Sua Jornada" (`dashboard/index.html.erb`)

Na tela principal do estudante, cada card de `Level` pode assumir um de **3 estados**:

1. **Nível Concluído (`level.completed_by?(Current.user) == true`):**
   - Renderizado como `<details>` desbloqueado (permitindo rejogar temas se desejar).
   - Badge superior direito: Fundo verde-esmeralda (`bg-emerald-100 text-emerald-800`), texto `Concluído` (`t("accessibility.completed")`).
   - Mostra a nota obtida pelo estudante no nível (ex: `85.0%`).
2. **Nível Atual / Em Progresso (`level.unlocked_for?(Current.user) == true` e `!level.completed_by?(Current.user)`):**
   - Renderizado como `<details open>` (ou recolhível) com borda destacada `border-2 border-emerald-400`.
   - Badge superior direito: `Em progresso` (`t("accessibility.in_progress")`).
   - Lista de Temas:
     - Temas já concluídos exibem um indicador visual de concluído (`✓ Concluído`) ao lado do botão de jogar novamente.
     - Temas pendentes exibem o botão `Iniciar Tema`.
3. **Nível Bloqueado (`level.unlocked_for?(Current.user) == false`):**
   - Renderizado com estilo acinzentado (`grayscale opacity-60`), ícone de cadeado e modal explicando a necessidade de atingir 70% no nível anterior.

## 2. Mapeamento das Ilustrações ODS (`level_image_path`)

- Os arquivos `public/ods-1.png` a `public/ods-5.png` representam a sequência pedagógica dos 5 níveis.
- Em vez de buscar pelo `level.id` bruto do banco (que muda após `db:seed:replant` ou recriação de níveis), o helper `level_image_path(level)` determinará o número sequencial do nível (`1..5`) com base na ordenação `Level.order(:id).pluck(:id).index(level.id) + 1`, garantindo que o 1º nível sempre use `ods-1.png`, o 2º use `ods-2.png`, etc., com fallback para `/logo_qta.png`.

## 3. Avatar do Estudante no Cabeçalho

- No cabeçalho superior de `dashboard/index.html.erb` e `play/questions/show.html.erb`, substituir o texto estático `"A"` por um link acessível para `profile_path` exibindo a primeira letra do `Current.user.full_name` em maiúscula, mantendo contraste mínimo WCAG AA (`bg-emerald-100 text-emerald-900`).

## 4. Padronização das Subtelas Administrativas (Paleta Emerald)

- Nas views `admin/themes/index.html.erb`, `admin/themes/_form.html.erb`, `admin/questions/index.html.erb`, `admin/questions/_form.html.erb`, `admin/levels/_form.html.erb` e `admin/admins/_form.html.erb`:
  - Substituir botões primários `bg-blue-700` por `bg-emerald-800 hover:bg-emerald-900` (ou `#064e3b`), mantendo consistência com a Sidebar e respeitando o contraste mínimo de 4.5:1 validado pelo Axe Core.

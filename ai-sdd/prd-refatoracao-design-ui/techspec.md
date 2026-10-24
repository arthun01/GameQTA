# Especificação Técnica - Refatoração de Design, UI/UX & Identidade Visual

## Visão Geral Técnica

Esta especificação técnica documenta as alterações estruturais e de estilização realizadas no frontend da aplicação através do Pull Request #17 (`ref-design`), de autoria de **Ana Beatriz Guerra Mello**. Não foram necessárias migrações no banco de dados; o foco concentrou-se na camada de apresentação (ERB, Tailwind CSS, Propshaft e integração de assets).

## Arquivos e Módulos Modificados

### 1. Camada de Views & Layouts

| Arquivo | Mudança Técnica |
|---------|-----------------|
| `app/views/layouts/application.html.erb` | Ajuste de metatags de viewport, classes de fundo e container geral. |
| `app/views/users/registrations/new.html.erb` | Aplicação da paleta emerald, inserção da `logo_qta.png`, inputs estilizados. |
| `app/views/users/sessions/new.html.erb` | Reestruturação visual do card de login e inclusão do rodapé institucional com créditos. |
| `app/views/dashboard/index.html.erb` | Redesign completo: inclusão da Navbar superior, mapeamento das imagens `ods-[1..5].png`, exibição numerada de temas. |
| `app/views/play/questions/show.html.erb` | Refatoração do layout de pergunta, container do YouTube embed, botões de alternativa e rodapé. |
| `app/views/play/questions/_evaluation.html.erb` | Ajuste nos estilos de feedback visual imediato (acerto/erro) e mensagens pedagógicas. |
| `app/views/admin/shared/_sidebar.html.erb` | Padronização dos links de navegação, ícones SVG e estados ativos na cor emerald. |
| `app/views/admin/dashboards/show.html.erb` | Estilização dos cards de métricas analíticas e estatísticas do sistema. |
| `app/views/admin/levels/index.html.erb` | Tabela de níveis com cabeçalhos padronizados e botões de ação uniformes. |
| `app/views/admin/students/index.html.erb` | Tabela de moderação de estudantes com badges de status e botões de bloqueio. |
| `app/views/admin/admins/index.html.erb` | Tabela e formulário de gestão de administradores alinhados à identidade. |
| `app/views/admin/reports/index.html.erb` | Interface de exportação e download de relatórios CSV reformulada. |
| `app/views/pwa/manifest.json.erb` | Atualização do `theme_color` para `#059669` e nome da aplicação. |

### 2. Assets Estáticos (`public/`)

- Adicionados:
  - `public/logo_qta.png`: Logo oficial em alta resolução do Game QTA.
  - `public/ods-1.png`, `public/ods-2.png`, `public/ods-3.png`, `public/ods-4.png`, `public/ods-5.png`: Ilustrações minimalistas em PNG com formato quadrado para os 5 Níveis temáticos.
  - `public/tekohalab.png`: Assinatura visual do laboratório TekohaLab / UESC.
- Removidos:
  - `public/icon.png` e `public/icon.svg` legados/genéricos de scaffold Rails.

### 3. Dependências e Gemfile.lock

- Commit `adc530a`: Atualização das dependências no `Gemfile.lock` para sincronização com o ambiente Rails 8.1.

### 4. Testes de Sistema (Capybara E2E)

- `test/system/admin/admins_test.rb`:
  - Atualização dos seletores de teste e assertivas de texto para refletir os novos botões e rótulos da interface administrativa padronizada.
  - Garantia de 100% de aprovação na suíte de testes automatizados (`bin/rails test`).

## Considerações de Performance

1. **Sem Overhead de JavaScript:** Todas as mudanças visuais foram realizadas exclusivamente via Tailwind CSS utility classes e ERB, respeitando o princípio de zero Node.js / Importmap.
2. **Imagens Otimizadas:** As ilustrações foram incorporadas com escala controlada para evitar layout shift (CLS) durante o carregamento inicial das páginas.

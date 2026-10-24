# Tarefa 1.0: Identidade Visual Base, Paleta Emerald e Telas de Autenticação

**Objetivo:** Estabelecer a paleta de cores oficial *Emerald*, incorporar a logo do Game QTA e refatorar as interfaces de Cadastro e Login com novos estilos e rodapé integrado.  
**Requisitos cobertos:** RF-001, RF-002, RF-003, RF-004  
**Responsável:** Ana Beatriz Guerra Mello  
**Status:** ✅ Concluído (Commits `adc530a`, `76a9704`, `39606c1`)

## Subtarefas Executadas

- [x] 1.1 **Assets:** Inserção do arquivo `public/logo_qta.png` e remoção dos ícones genéricos de scaffold.
- [x] 1.2 **Tela de Cadastro:** Refatoração de `app/views/users/registrations/new.html.erb` adotando a paleta emerald (`emerald-600`, `focus:ring-emerald-500`) e centralizando a logo oficial.
- [x] 1.3 **Tela de Login:** Refatoração de `app/views/users/sessions/new.html.erb` com visual clean e rodapé com identificação institucional.
- [x] 1.4 **Configuração PWA:** Atualização de `app/views/pwa/manifest.json.erb` com `theme_color` ajustado para `#059669`.
- [x] 1.5 **Sincronização de Dependências:** Atualização do `Gemfile.lock` garantindo integridade das bibliotecas frontend/CSS.

## Arquivos Relacionados
- `public/logo_qta.png` (Novo)
- `app/views/users/registrations/new.html.erb`
- `app/views/users/sessions/new.html.erb`
- `app/views/pwa/manifest.json.erb`
- `Gemfile.lock`

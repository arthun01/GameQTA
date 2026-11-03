# Verificação de acessibilidade

Data: 03/11/2026. Referência: WCAG 2.1 A e AA. Não é declaração de conformidade integral: axe detecta parte dos problemas e a operação com leitor de tela humano, equivalência audiovisual e uso por pessoas com deficiência ainda precisam de avaliação.

## Cobertura executada

Axe Core 4.14, tags wcag2a, wcag2aa, wcag21a, wcag21aa: login estudantil, cadastro, termos, privacidade, login administrativo, jornada, ranking, perfil, edição de perfil, preparação/revelação de questão, dashboard administrativo, estudantes, relatórios, administradores, níveis, temas e formulário de questão. Testes de teclado abrem/fecham dialog e verificam retorno do foco; alternativas permitem escolha antes do envio explícito. A página `/acessibilidade` documenta controles e limites. Resultados detalhados regeneráveis em `tmp/a11y/`, sem dados de usuários reais.

## Matriz de critérios e limites

| Critérios WCAG | Medidas / verificação | Estado |
|---|---|---|
| 1.1.1 conteúdo não textual | Alt na marca, nível e imagens; SVG decorativo oculto; fallback local no servidor | Implementado nas telas auditadas; conteúdo futuro deve manter regra |
| 1.2.1–1.2.5 mídia | Player nomeado, bloqueável; texto da questão e feedback disponíveis | Parcial: professor precisa validar legendas, transcrições, audiodescrição/alternativas conforme cada vídeo |
| 1.3.1–1.3.3 semântica | Labels, fieldset/legend, título de página, idioma, regiões, dialog nomeado, erros associados | Axe e HTML verificados; leitura com tecnologia assistiva pendente |
| 1.4.1, 1.4.3 e 1.4.11 cor/contraste | Verde mais escuro com branco, textos mutados, controles com borda; acerto/erro também por texto | Axe nas telas/estados testados sem violações; manter revisão de conteúdo dinâmico |
| 1.4.4, 1.4.10, 1.4.12 ampliação/reflow/espaçamento | Layout fluido, administração vertical no celular e textos quebráveis | Verificação móvel; grade de todas as combinações de navegador/zoom não certificada |
| 2.1.1, 2.1.2 teclado | Controles nativos, radios visíveis, confirmação explícita, Escape e foco em dialog nativo | Testes funcionais passaram; nenhuma resposta enviada só ao selecionar |
| 2.2.1 tempo | Escolha de 1 a 10× antes da revelação, servidor guarda limite; reload não reinicia; prazo usa referência de servidor e âncora monotônica, independente do relógio local | Implementado para todos; pontos iguais, tempo real desempata; classificação não é teste padronizado de capacidade |
| 2.2.2 movimento | Sem pulsação do timer, preferência reduced-motion respeitada | CSS e comportamento verificados |
| 2.3.1 flashes | Não foram adicionados efeitos de flashes | Vídeos de terceiros exigem revisão editorial |
| 2.4.1–2.4.7 navegação/foco | Skip link, foco global contrastante, títulos, links nomeados, foco na questão e dialog | Teclado e axe; testar leitores de tela reais antes de declaração integral |
| 2.5.1–2.5.4 entrada | Controles nativos, sem gestos complexos ou movimento do dispositivo, nomes consistentes | Axe e inspeção dos controles auditados |
| 3.1.1–3.1.2 idioma | lang pt-BR nos layouts e instruções em português | Implementado; trechos de conteúdo cadastrado dependem de edição |
| 3.2.1–3.2.4 previsibilidade | Selecionar alternativa não envia; rótulos/controles consistentes | Testado no jogo; não presume conformidade de páginas futuras |
| 3.3.1–3.3.4 formulários/erros | Erros por campo com aria-invalid/describedby, preservação de valores e confirmação de exclusão | Testes de cadastro/perfil/admin; avaliação humana continua recomendada |
| 4.1.1–4.1.3 compatibilidade/estado | IDs únicos, nomes/roles, flash status, timer aria-live off e anúncio pontual aos 20s | Axe e DOM verificados; não equivale a teste NVDA/Orca |

## Correções de causa raiz e testes existentes

Os imports relativos de `controllers/index.js` pediam URLs sem extensão que retornavam 404 no Propshaft. O carregamento via eagerLoadControllersFrom e pins locais resolveu o problema para todos os controladores, incluindo nested-form, modal e timer. Testes antigos presumiam seletores `.group`, envio automático e a presença de Dashboard como confirmação de login (texto também existente no menu antes de autenticar); passaram a aguardar rota autenticada e controles reais. Nenhum teste foi desativado e nenhuma regra foi relaxada para ocultar falha.

## Pendências editoriais e humanas

O responsável deve conferir cada vídeo e publicar alternativas equivalentes quando necessárias, testar com leitor de tela e usuários, registrar problemas e retestar a produção com conteúdo real. Não há leitor de tela operado nesta sessão. Ferramentas automáticas podem retornar casos incompletos que precisam de revisão; não são descartados como aprovados. O PDF é material visual, sem certificação de PDF acessível/tagueado; os textos HTML são a alternativa disponível.

Fontes: [WCAG 2.1](https://www.w3.org/TR/WCAG21/), [tempo ajustável](https://www.w3.org/WAI/WCAG21/Understanding/timing-adjustable.html), [dialog WAI](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/).

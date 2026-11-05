# Auditoria de cookies e conexões externas

Data: 03/11/2026. Escopo: código do repositório, navegadores de teste e configuração de produção. Não inclui infraestrutura ainda não contratada, extensões do navegador ou serviços que venham a ser adicionados.

## Inventário implementado

| Nome / origem | Finalidade | Duração no navegador e servidor | Proteção / categoria |
|---|---|---|---|
| `_qta_rails8_session`, aplicação | Navegação, retorno após login e proteção de formulários | Até 12 horas após uso; pode ser renovado com a navegação | CookieStore criptografado; HttpOnly, SameSite=Lax, Secure em produção; necessário |
| `user_session_id`, aplicação | Referenciar sessão do estudante | 12 horas desde o login; consulta rejeita registro mais antigo, mesmo que o cookie seja reapresentado | Assinado, HttpOnly, SameSite=Lax, Secure em produção; necessário |
| `session_id`, aplicação | Referenciar sessão administrativa | 12 horas desde o login, com a mesma expiração no servidor | Assinado, HttpOnly, SameSite=Lax, Secure em produção; necessário |
| Player YouTube/Google | Exibir vídeo escolhido na página | Não é iniciado automaticamente; fornecedor controla tecnologias/durações após ativação | Opcional, bloqueado até escolha por vídeo; domínio youtube-nocookie não significa ausência de dados/cookies |

A validade do acesso não define retenção do registro no banco. A equipe ainda precisa decidir guarda, limpeza dos registros de sessão e logs, backups e exportações. Logout destrói a sessão correspondente no servidor. Cookies próprios não guardam senha. A sessão administrativa não substitui a estudantil.

## Conexões e escolha

Google Fonts e preconnects removidos; fontes do dispositivo, assets e bibliotecas servidos pela aplicação. Nenhum analytics, pixel de anúncios ou CDN externo foi encontrado no código ativo. Links para terceiros só conectam após navegação voluntária. Não há thumbnail remota, iframe, script ou preconnect do YouTube na carga inicial.

A interface informa que carregar um vídeo compartilha dados de conexão com Google/YouTube. Oferece botões de igual destaque para carregar ou continuar sem vídeo, e botão para remover o player após carregar. Escolha não é persistida em cookie, localStorage ou banco e é removida antes do cache Turbo. Navegar, recarregar ou revelar a questão começa com vídeo desligado. Revogar impede novas conexões daquele player, mas não apaga dados já recebidos. Essa escolha não é interpretada como autorização parental, consentimento de pesquisa ou validação jurídica do fornecedor para crianças.

O aviso de cookies está no fluxo do rodapé, sem sobreposição, bloqueio de jogo ou botão de aceite genérico. Não afirma que o fornecedor externo utiliza apenas cookies essenciais. No modo sem JavaScript, o player permanece desligado e a questão pode ser respondida por HTML.

## Evidências e limites

`CookiePrivacyTest` verifica atributos de cookie, logout, expiração no servidor e HTML sem recursos externos automáticos. `AccessibilityTest` verifica ausência de requisições externas observadas antes da escolha, rejeição, ativação, desativação e reset ao revelar a questão. Testes locais não substituem conferência HTTPS no domínio definitivo. Produção força HTTPS, exceto healthcheck `/up`; proxy precisa encaminhar corretamente o protocolo e possuir certificado válido.

O professor deve revisar adequação dos vídeos, legendas, conteúdo, classificação e requisitos do fornecedor para sites direcionados a crianças antes da liberação pública. A duração e o comportamento das tecnologias do YouTube podem mudar; não são apresentados como controlados pela aplicação. Nova integração exige inventário e avaliação antes de ativação.

Referências: [ANPD cookies](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_orientativo_cookies_e_protecao_de_dados_pessoais), [Rails cookies](https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html), [YouTube incorporações](https://support.google.com/youtube/answer/171780?hl=pt-BR).

## Cache privado

Além de no-store HTTP, layouts com formulários/áreas privadas desativam snapshots Turbo com meta no-cache. Logout limpa o cache Turbo. Teste de histórico após sair verifica que o perfil é revalidado e o e-mail não reaparece.

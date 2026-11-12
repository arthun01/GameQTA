# Tarefa 11.0: Vídeo simples e tempo automático com preferência no perfil

Requisitos: simplificação autorizada em 10/11/2026, RF-023, RF-024 e RF-025 a RF-032, preservando segurança e prazos.

- [x] Remover a seleção de tempo do jogo e o botão redundante de recusa do vídeo; manter aviso curto, vídeo por clique e desativação.
- [x] Adicionar preferência de conta com padrão 1, validação de 1 a 10 e migração reversível.
- [x] Expor ajuste recolhível no perfil e recurso PATCH próprio, somente para a conta autenticada e sem senha adicional.
- [x] Aplicar a preferência às novas questões e preservar prazo de questões já reveladas, ignorando parâmetro enviado pelo jogo.
- [x] Atualizar README, PRD/design/techspec, inventário de tratamento e documentos públicos 1.1.
- [x] Regenerar e conferir visualmente o PDF formal, alinhado aos textos integrais.
- [x] Aprovar verificações de qualidade e testes de aplicação/navegador, incluindo acessibilidade.
- [x] Publicar commit e atualizar PR #23 com evidências e migração necessária.

Os testes incluem configuração padrão, persistência entre acessos, alteração inválida, isolamento da conta, aceite pendente, restauração do padrão, proteção do prazo e ausência de conexão externa antes de assistir. Testes de navegador verificam o perfil no celular e a opção de jogar sem vídeo.

# Revisão antes do PR

Data: 03/11/2026. Comparação: `main...rafael`, base a38f55a5b4b0385027f47b551fe2bfc8a27a50cf. Inclui as entregas anteriores de Termos/Privacidade, aceite/perfil/exclusão e cadastro direto. Revisão automatizada em dois eixos independentes, seguida de correções, rechecagem e testes; não é parecer jurídico ou revisão humana de acessibilidade.

## Standards

Nenhuma nova violação estrutural relevante: decisões nos models, controllers novos REST, i18n e ausência de services/JS inline. Dois achados iniciais:

1. **P1: snapshots privados do Turbo.** No-store HTTP sozinho não impede restauração do HTML após sair. Corrigido com meta no-cache nos layouts, no-store administrativo e limpeza do cache no logout. Regressão de Voltar após logout não expõe os dados do perfil.
2. **P2: aceite de conta legada.** Update do timestamp acionava validações novas de campos antigos e podia gerar 500. Corrigido com touch específico dentro do mesmo lock/transação; teste com nome legado maior que o limite confirma aceite sem alterar perfil.

A rechecagem identificou **P2 de relógio local** no primeiro ajuste do prazo absoluto: Date.now adiantado poderia disparar timeout. Corrigido com diferença entre dois instantes do servidor e âncora monotônica performance.now preservada em reconnects. Teste adianta Date.now em 24h sem submissão prematura. Rechecagem final não encontrou outro erro concreto nessa correção.

## Spec

Dois achados iniciais de RF-029/proteção de cache:

1. **P2: cronômetro reiniciava visualmente no snapshot.** Corrigido com prazo absoluto do servidor e referência monotônica; recarregar continua respeitando o prazo persistido.
2. **P2: cache privado incompleto.** Corrigido conforme o eixo Standards.

Rechecagem confirmou as correções e a vinculação da resposta à submission_id buscada dentro da tentativa autenticada. Formulário antigo não encerra outra questão. Não foi identificado escopo adicional indevido. Pendências de base legal, operação, vídeos e avaliação humana estão registradas, sem alegação de conformidade integral.

## Resultado e limites

Achados técnicos identificados foram tratados e receberam regressões. Checks finais e resultados estão no tasks.md. O PR preserva dados existentes e não publica em produção. As decisões para disponibilização pública constam de pendencias-publicacao.md e não são declaradas resolvidas por esta revisão.

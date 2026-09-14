# Tarefa 1.0: Infraestrutura de Usuário (Banco e Modelos)

> **Referências obrigatórias**: Antes de iniciar, leia `prd.md` e `techspec.md` desta pasta. A tarefa será invalidada sem essa leitura.

## Visão Geral

Estabelece a fundação de banco de dados para os alunos, criando as tabelas `User` e `UserSession` independentes da autenticação de Administrador construída na Fase 1.

## Requisitos Atendidos

- RF-001: Captura de dados (Nome, Idade, Cidade, etc).
- RF-002: Enumeração obrigatória de Escolaridade.

## Conformidade com Standards

- **AGENTS.md**: Regras do banco via ActiveRecord, uso de migrações em vez de editar o schema diretamente.
- O enum deve espelhar estritamente os requisitos de strings definidos na Tech Spec.

## Subtarefas

- [ ] 1.1 Gerar o modelo `User` com atributos definidos (full_name, age, city, education_level, email_address, password_digest).
- [ ] 1.2 Gerar o modelo `UserSession` associado.
- [ ] 1.3 Implementar o `enum :education_level` e as validações de presença (`validates`) no model `User`.
- [ ] 1.4 Adicionar chaves de tradução no `pt-BR.yml` para os valores do enum (se necessário).

## Detalhes de Implementação

- **Referência**: Ver seção "Modelos de Dados" em `techspec.md`.
- **Pontos de atenção**: Certifique-se de que a migração contém restrições de `null: false` para evitar lixo no banco.

## Critérios de Sucesso

- [ ] As tabelas `users` e `user_sessions` existem.
- [ ] É impossível criar um `User` sem informar cidade, idade, ou nome.
- [ ] Todos os testes passando.

## Testes

> **Obrigatório**: Crie e execute todos os testes antes de considerar a tarefa finalizada.

### Testes Unitários
- [ ] `UserTest`: Tentar salvar sem parâmetros requeridos e validar recusa.
- [ ] `UserTest`: Passar valores inválidos para o `education_level` e confirmar exceção do ActiveRecord.
- [ ] `UserTest`: Sucesso total preenchendo todos os campos corretamente.

## Arquivos Relevantes

- `db/migrate/..._create_users.rb` — Novo — Migração principal
- `app/models/user.rb` — Novo — Regras de negócio
- `app/models/user_session.rb` — Novo — Controle de sessão

## Dependências

- Nenhuma.


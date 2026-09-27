# Documentação Oficial do Projeto Game QTA

Bem-vindo ao portal de documentação do Game QTA. Este diretório foi criado para servir como fonte única de verdade (Single Source of Truth) para desenvolvedores, administradores e mantenedores do projeto.

A documentação não é excessivamente longa, mas é focada em ser **extremamente útil e pragmática**. Se você tem uma dúvida sobre como o sistema funciona ou como deve ser estendido, a resposta está aqui.

## 📚 Índice de Guias

### 1. [Regras de Negócio & Escopo](./BUSINESS_RULES.md)
O coração lógico do projeto. Entenda como funcionam as pontuações, desempates do ranking, progressão de nível (regra dos 70%), moderação anti-cheat e as hierarquias de banco de dados.

### 2. [Guia de Desenvolvimento & Padrões](./DEVELOPMENT_GUIDE.md)
Leitura **obrigatória** para qualquer novo desenvolvedor na equipe. Descreve a arquitetura ("The Rails Way"), stack tecnológica (Hotwire, Tailwind, Solid Queue), guias de estilo e os comandos essenciais antes de abrir um Pull Request.

### 3. [Guia do Administrador (Backoffice)](./ADMIN_GUIDE.md)
Manual focado em quem vai operar o sistema no dia a dia. Explica como estruturar as aulas (Nível > Tema > Questão), como gerenciar a comunidade (Banimentos) e como extrair relatórios CSV sem derrubar o servidor.

### 4. [Guia do Usuário Final (Estudante)](./USER_GUIDE.md)
Documentação do fluxo e da experiência do estudante. Como ele se cadastra, como o tempo das perguntas afeta sua pontuação e como ele interage com a plataforma gamificada.

---

> **Nota aos Desenvolvedores:** Mantenha esta documentação viva. Se uma nova regra de negócio complexa for introduzida, atualize o `BUSINESS_RULES.md`. Se uma nova biblioteca padrão for adotada, atualize o `DEVELOPMENT_GUIDE.md`.

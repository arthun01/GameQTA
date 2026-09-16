# db/seeds.rb
# População inicial da base de dados do Game QTA

puts "== Limpando dados anteriores =="
Option.destroy_all
QuestionSubmission.destroy_all
Question.destroy_all
ThemeAttempt.destroy_all
Theme.destroy_all
Level.destroy_all
UserSession.destroy_all if defined?(UserSession)
Session.destroy_all if defined?(Session)

puts "== Criando Configurações Gerais =="
GameSetting.find_or_create_by!(id: 1) do |setting|
  setting.easy_time_seconds = 60
  setting.medium_time_seconds = 45
  setting.hard_time_seconds = 30
end

puts "== Criando Usuários Base =="
admin = Admin.find_or_create_by!(email_address: "admin@qta.uesc.br") do |a|
  a.password = "password123"
  a.password_confirmation = "password123"
end
puts "-> Admin criado: admin@qta.uesc.br / password123"

student = User.find_or_create_by!(email_address: "estudante@qta.uesc.br") do |u|
  u.full_name = "Estudante Exemplar"
  u.age = 16
  u.city = "Ilhéus - BA"
  u.education_level = :medio_incompleto
  u.password = "password123"
  u.password_confirmation = "password123"
end
puts "-> Estudante criado: estudante@qta.uesc.br / password123"

puts "== Criando Árvore de Conhecimento (Níveis, Temas, Questões) =="

# -------------------------------------------------------------
# NÍVEL 1: FUNDAMENTOS DO DIREITO AMBIENTAL
# -------------------------------------------------------------
level_1 = Level.create!(
  name: "Fundamentos do Direito Ambiental",
  description: "Introdução aos princípios estruturantes, garantias constitucionais e deveres do Poder Público e da coletividade.",
  icon: "🌱"
)

# Tema 1.1
theme_1_1 = level_1.themes.create!(
  name: "Princípios e Art. 225 da CF/88",
  description: "O direito ao meio ambiente ecologicamente equilibrado como direito fundamental de terceira geração.",
  icon: "🏛️"
)

q = theme_1_1.questions.build(
  statement: "Segundo o caput do Art. 225 da Constituição Federal de 1988, a quem incumbe o dever de defender e preservar o meio ambiente para as presentes e futuras gerações?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Art. 225 da CF/88 estabelece que todos têm direito ao meio ambiente ecologicamente equilibrado, impondo-se ao Poder Público e à coletividade o dever de defendê-lo e preservá-lo."
)
q.options.build(content: "Ao Poder Público e à coletividade.", is_correct: true)
q.options.build(content: "Exclusivamente aos órgãos ambientais federais (IBAMA/ICMBio).", is_correct: false)
q.options.build(content: "Apenas às empresas e indústrias potencialmente poluidoras.", is_correct: false)
q.options.build(content: "Exclusivamente aos proprietários de terras rurais.", is_correct: false)
q.save!

q = theme_1_1.questions.build(
  statement: "Como a doutrina jurídica classifica o direito ao meio ambiente equilibrado em relação às gerações de direitos fundamentais?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O direito ambiental é classificado como um direito de 3ª geração (ou dimensão), pois tutela interesses difusos e transindividuais, ligados à solidariedade e fraternidade."
)
q.options.build(content: "Direito de 3ª geração (interesses difusos e solidariedade).", is_correct: true)
q.options.build(content: "Direito de 1ª geração (liberdades individuais negativas).", is_correct: false)
q.options.build(content: "Direito de 2ª geração (direitos sociais e econômicos prestacionais).", is_correct: false)
q.options.build(content: "Não é considerado um direito fundamental pela Constituição.", is_correct: false)
q.save!

q = theme_1_1.questions.build(
  statement: "O princípio que determina que a proteção ambiental deve considerar as necessidades das futuras gerações é chamado de:",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Trata-se do princípio da solidariedade intergeracional, explícito no comando constitucional de preservar para as 'presentes e futuras gerações'."
)
q.options.build(content: "Princípio da Solidariedade Intergeracional.", is_correct: true)
q.options.build(content: "Princípio da Supremacia do Interesse Econômico.", is_correct: false)
q.options.build(content: "Princípio da Territorialidade Estrita.", is_correct: false)
q.options.build(content: "Princípio do Livre Mercado Irrestrito.", is_correct: false)
q.save!

# Tema 1.2
theme_1_2 = level_1.themes.create!(
  name: "Poluidor-Pagador e Usuário-Pagador",
  description: "Internalização das externalidades ambientais negativas e custos do uso dos recursos naturais.",
  icon: "💰"
)

q = theme_1_2.questions.build(
  statement: "O Princípio do Poluidor-Pagador (PPP) tem como principal objetivo:",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O princípio visa internalizar os custos ambientais no processo produtivo (evitando que a sociedade pague pela degradação) e promover a reparação do dano, não concedendo direito de poluir."
)
q.options.build(content: "Internalizar os custos ecológicos e impor ao poluidor a obrigação de recuperar e indenizar.", is_correct: true)
q.options.build(content: "Conceder uma licença para poluir livremente a quem tiver condições financeiras de pagar taxas.", is_correct: false)
q.options.build(content: "Isentar pequenas e médias empresas de qualquer responsabilidade ecológica.", is_correct: false)
q.options.build(content: "Substituir todas as multas administrativas por doações voluntárias.", is_correct: false)
q.save!

q = theme_1_2.questions.build(
  statement: "Qual é a diferença conceitual fundamental entre o Princípio do Poluidor-Pagador e o Princípio do Usuário-Pagador?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Usuário-Pagador cobra pelo uso lícito e regular de recursos naturais escassos (ex: outorga de água), enquanto o Poluidor-Pagador foca na prevenção, controle e reparação de impactos e poluição."
)
q.options.build(content: "O Usuário-Pagador remunera pelo uso de recurso escasso, enquanto o Poluidor-Pagador foca no custeio e reparação de impactos.", is_correct: true)
q.options.build(content: "Não existe distinção, ambos tratam exclusivamente de sanções punitivas após a prática de crime ambiental.", is_correct: false)
q.options.build(content: "O Poluidor-Pagador aplica-se apenas a pessoas físicas e o Usuário-Pagador a pessoas jurídicas.", is_correct: false)
q.options.build(content: "O Usuário-Pagador foi revogado pela Lei da Política Nacional do Meio Ambiente.", is_correct: false)
q.save!

# Tema 1.3
theme_1_3 = level_1.themes.create!(
  name: "Precaução vs. Prevenção",
  description: "Mecanismos de tutela diante do perigo abstrato, risco científico e certeza de dano.",
  icon: "🛡️"
)

q = theme_1_3.questions.build(
  statement: "Quando há incerteza científica sobre a gravidade ou irreversibilidade de um dano ambiental, qual princípio impõe a adoção de medidas protetivas?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Princípio da Precaução atua exatamente diante da dúvida ou incerteza científica (in dubio pro natura), exigindo cautela preventiva antes que danos irreversíveis ocorram."
)
q.options.build(content: "Princípio da Precaução.", is_correct: true)
q.options.build(content: "Princípio da Prevenção.", is_correct: false)
q.options.build(content: "Princípio do Desenvolvimento Econômico Prioritário.", is_correct: false)
q.options.build(content: "Princípio da Legalidade Estrita.", is_correct: false)
q.save!

q = theme_1_3.questions.build(
  statement: "O Princípio da Prevenção incide sobre situações em que o risco ambiental é:",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Na Prevenção, o perigo e o impacto já são conhecidos e cientificamente comprovados (ex: estudo prévio de impacto para uma represa)."
)
q.options.build(content: "Conhecido e cientificamente comprovado.", is_correct: true)
q.options.build(content: "Totalmente hipotético e sem base técnica existente.", is_correct: false)
q.options.build(content: "Irrelevante para o licenciamento ordinário.", is_correct: false)
q.options.build(content: "Exclusivo de catástrofes naturais imprevisíveis.", is_correct: false)
q.save!

# -------------------------------------------------------------
# NÍVEL 2: POLÍTICA NACIONAL DO MEIO AMBIENTE (PNMA)
# -------------------------------------------------------------
level_2 = Level.create!(
  name: "Política Nacional do Meio Ambiente",
  description: "Estrutura do SISNAMA, instrumentos de comando e controle, e o processo de licenciamento ambiental.",
  icon: "📜"
)

# Tema 2.1
theme_2_1 = level_2.themes.create!(
  name: "SISNAMA e Órgãos Ambientais",
  description: "A composição e articulação dos órgãos federais, estaduais e municipais na gestão ambiental.",
  icon: "🏢"
)

q = theme_2_1.questions.build(
  statement: "Qual é o órgão consultivo e deliberativo do SISNAMA responsável por formular diretrizes e normas ambientais no Brasil?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O CONAMA (Conselho Nacional do Meio Ambiente) é o órgão consultivo e deliberativo do SISNAMA, editando resoluções normativas vinculantes."
)
q.options.build(content: "CONAMA (Conselho Nacional do Meio Ambiente).", is_correct: true)
q.options.build(content: "IBAMA (Instituto Brasileiro do Meio Ambiente).", is_correct: false)
q.options.build(content: "ICMBio (Instituto Chico Mendes).", is_correct: false)
q.options.build(content: "Ministério da Fazenda.", is_correct: false)
q.save!

q = theme_2_1.questions.build(
  statement: "Qual o papel institucional do IBAMA dentro da estrutura do SISNAMA?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O IBAMA atua como órgão executor federal, responsável pela fiscalização, controle ambiental e licenciamento de competência federal."
)
q.options.build(content: "Órgão executor federal responsável pela fiscalização e controle ambiental.", is_correct: true)
q.options.build(content: "Órgão superior exclusivo para julgamento de crimes militares.", is_correct: false)
q.options.build(content: "Órgão legislativo encarregado de criar leis federais.", is_correct: false)
q.options.build(content: "Conselho internacional sem poderes de autuação no Brasil.", is_correct: false)
q.save!

# Tema 2.2
theme_2_2 = level_2.themes.create!(
  name: "Licenciamento Ambiental",
  description: "O rito trifásico: Licença Prévia (LP), Licença de Instalação (LI) e Licença de Operação (LO).",
  icon: "📑"
)

q = theme_2_2.questions.build(
  statement: "Qual é a sequência cronológica correta do modelo clássico trifásico de licenciamento ambiental no Brasil?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "A ordem regular é: 1º Licença Prévia (LP) para atestar viabilidade locacional, 2º Licença de Instalação (LI) para construir, 3º Licença de Operação (LO) para funcionar."
)
q.options.build(content: "Licença Prévia (LP) -> Licença de Instalação (LI) -> Licença de Operação (LO).", is_correct: true)
q.options.build(content: "Licença de Operação (LO) -> Licença Prévia (LP) -> Licença de Instalação (LI).", is_correct: false)
q.options.build(content: "Licença de Instalação (LI) -> Licença de Operação (LO) -> Licença Prévia (LP).", is_correct: false)
q.options.build(content: "Licença Provisória -> Licença Definitiva -> Licença de Isenção.", is_correct: false)
q.save!

q = theme_2_2.questions.build(
  statement: "A Licença Prévia (LP) autoriza o início imediato das obras de construção do empreendimento?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Não! A Licença Prévia apenas atesta a viabilidade ambiental e locacional do projeto. O início das obras só é autorizado com a Licença de Instalação (LI)."
)
q.options.build(content: "Não, a LP apenas atesta a viabilidade e localização; o início das obras exige a LI.", is_correct: true)
q.options.build(content: "Sim, a LP autoriza tanto a construção quanto o funcionamento pleno.", is_correct: false)
q.options.build(content: "Sim, desde que a empresa pague uma caução financeira ao município.", is_correct: false)
q.options.build(content: "Apenas se o empreendimento for de pequeno porte residencial.", is_correct: false)
q.save!

# Tema 2.3
theme_2_3 = level_2.themes.create!(
  name: "Avaliação de Impacto (EIA/RIMA)",
  description: "Exigência constitucional para instalação de obra ou atividade potencialmente causadora de significativa degradação.",
  icon: "🔍"
)

q = theme_2_3.questions.build(
  statement: "O Estudo Prévio de Impacto Ambiental (EIA) e seu respectivo Relatório (RIMA) são exigidos constitucionalmente quando a atividade for causadora de:",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Art. 225, § 1º, IV da CF/88 exige o EIA/RIMA para instalação de obra ou atividade potencialmente causadora de significativa degradação do meio ambiente."
)
q.options.build(content: "Significativa degradação do meio ambiente.", is_correct: true)
q.options.build(content: "Qualquer impacto mínimo, mesmo que corriqueiro e doméstico.", is_correct: false)
q.options.build(content: "Prejuízos financeiros exclusivos a acionistas privados.", is_correct: false)
q.options.build(content: "Alteração estética em praças públicas municipais.", is_correct: false)
q.save!

q = theme_2_3.questions.build(
  statement: "Qual é a principal função do RIMA (Relatório de Impacto Ambiental) em relação à sociedade?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O RIMA traduz as conclusões técnicas do EIA em linguagem acessível e compreensível para possibilitar a participação popular em audiências públicas."
)
q.options.build(content: "Apresentar as conclusões em linguagem clara e acessível para consulta pública.", is_correct: true)
q.options.build(content: "Garantir sigilo absoluto sobre os impactos industriais aos cidadãos.", is_correct: false)
q.options.build(content: "Definir o valor venal de impostos cobrados pela prefeitura.", is_correct: false)
q.options.build(content: "Substituir a necessidade de qualquer fiscalização estatal.", is_correct: false)
q.save!

# -------------------------------------------------------------
# NÍVEL 3: RECURSOS HÍDRICOS E SANEAMENTO
# -------------------------------------------------------------
level_3 = Level.create!(
  name: "Recursos Hídricos e Saneamento",
  description: "A gestão das águas doces no Brasil, bacias hidrográficas, instrumentos de outorga e o marco legal do saneamento.",
  icon: "💧"
)

# Tema 3.1
theme_3_1 = level_3.themes.create!(
  name: "Lei das Águas (Lei 9.433/97)",
  description: "Fundamentos legais da água como bem de domínio público e recurso natural limitado dotado de valor econômico.",
  icon: "🌊"
)

q = theme_3_1.questions.build(
  statement: "Segundo a Lei Federal nº 9.433/97, a água no Brasil é caracterizada juridicamente como:",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Art. 1º, I da Lei 9.433/97 define que 'a água é um bem de domínio público', não existindo propriedade privada sobre mananciais naturais."
)
q.options.build(content: "Um bem de domínio público e recurso limitado dotado de valor econômico.", is_correct: true)
q.options.build(content: "Propriedade privada absoluta do dono da terra onde nasce a nascente.", is_correct: false)
q.options.build(content: "Bem de consumo comercial sem qualquer restrição de captação.", is_correct: false)
q.options.build(content: "Propriedade exclusiva do governo federal inalienável a qualquer uso.", is_correct: false)
q.save!

q = theme_3_1.questions.build(
  statement: "Em situações de escassez hídrica crítica, quais são os usos prioritários da água determinados pela legislação?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Em situações de escassez, o uso prioritário dos recursos hídricos é o consumo humano e a dessedentação de animais (Art. 1º, III, Lei 9.433/97)."
)
q.options.build(content: "Consumo humano e dessedentação de animais.", is_correct: true)
q.options.build(content: "Geração de energia elétrica e navegação comercial.", is_correct: false)
q.options.build(content: "Irrigação de lavouras e atividade minerária.", is_correct: false)
q.options.build(content: "Uso industrial e recreação turística.", is_correct: false)
q.save!

# Tema 3.2
theme_3_2 = level_3.themes.create!(
  name: "Comitês de Bacia Hidrográfica",
  description: "A unidade territorial de gestão descentralizada e participativa conhecida como o 'Parlamento das Águas'.",
  icon: "🗺️"
)

q = theme_3_2.questions.build(
  statement: "Qual é a unidade territorial básica para a implementação da Política Nacional de Recursos Hídricos?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "A bacia hidrográfica é a unidade territorial básica para planejamento e gestão dos recursos hídricos, superando divisões político-administrativas de municípios."
)
q.options.build(content: "A bacia hidrográfica.", is_correct: true)
q.options.build(content: "O limite do município.", is_correct: false)
q.options.build(content: "A divisa estadual.", is_correct: false)
q.options.build(content: "O bioma continental.", is_correct: false)
q.save!

q = theme_3_2.questions.build(
  statement: "Por que os Comitês de Bacia Hidrográfica são chamados de 'Parlamentos das Águas'?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Porque possuem composição colegiada e tripartite: representantes do Poder Público, usuários da água (empresas/agricultores) e sociedade civil organizada."
)
q.options.build(content: "Porque reúnem de forma tripartite o Poder Público, usuários da água e a sociedade civil.", is_correct: true)
q.options.build(content: "Porque votam leis e emendas à Constituição Federal brasileira.", is_correct: false)
q.options.build(content: "Porque são compostos exclusivamente por deputados e senadores eleitos.", is_correct: false)
q.options.build(content: "Porque julgam e aplicam penas de prisão para crimes hediondos.", is_correct: false)
q.save!

# Tema 3.3
theme_3_3 = level_3.themes.create!(
  name: "Outorga de Direito de Uso",
  description: "Instrumento administrativo de controle quantitativo e qualitativo dos usos das águas.",
  icon: "🚰"
)

q = theme_3_3.questions.build(
  statement: "A outorga de direito de uso de recursos hídricos confere ao outorgado a propriedade definitiva sobre a água?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Não! A outorga é apenas uma autorização de uso precária e temporária, não alienando nem transferindo a propriedade da água, que permanece pública."
)
q.options.build(content: "Não, a outorga é ato precário e temporário de direito de uso, sem alienação do bem público.", is_correct: true)
q.options.build(content: "Sim, o beneficiário passa a ser o proprietário perpétuo daquele volume de água.", is_correct: false)
q.options.build(content: "Sim, podendo revender a água no mercado financeiro livremente.", is_correct: false)
q.options.build(content: "Apenas se for outorga para uso industrial minerário.", is_correct: false)
q.save!

q = theme_3_3.questions.build(
  statement: "Qual das seguintes hipóteses independe de outorga pelo Poder Público?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Art. 12, § 1º da Lei 9.433/97 dispensa de outorga o uso de recursos hídricos para satisfação das necessidades de pequenos núcleos populacionais no meio rural."
)
q.options.build(content: "Uso para satisfação de necessidades de pequenos núcleos populacionais rurais.", is_correct: true)
q.options.build(content: "Derivação de água para grandes projetos de irrigação agroindustrial.", is_correct: false)
q.options.build(content: "Captação de água para resfriamento de turbinas termoelétricas.", is_correct: false)
q.options.build(content: "Lançamento de efluentes industriais em corpos hídricos navegáveis.", is_correct: false)
q.save!

# Tema 3.4
theme_3_4 = level_3.themes.create!(
  name: "Marco Legal do Saneamento",
  description: "Diretrizes nacionais para abastecimento de água, esgotamento sanitário, resíduos sólidos e drenagem urbana.",
  icon: "🚿"
)

q = theme_3_4.questions.build(
  statement: "O Marco Legal do Saneamento Básico (Lei 14.026/2020) estabeleceu metas de universalização até 2033. Quais são os percentuais mínimos exigidos?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "A lei estabeleceu o atendimento de 99% da população com água potável e 90% da população com coleta e tratamento de esgotos até 31 de dezembro de 2033."
)
q.options.build(content: "99% da população com água potável e 90% com coleta e tratamento de esgoto.", is_correct: true)
q.options.build(content: "50% de água e 50% de esgoto tratado.", is_correct: false)
q.options.build(content: "100% de água e 30% de esgoto apenas em capitais.", is_correct: false)
q.options.build(content: "75% para todas as categorias sem prazos fixados.", is_correct: false)
q.save!

q = theme_3_4.questions.build(
  statement: "Quais são os 4 componentes integrados que compõem o conceito legal de saneamento básico?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O saneamento básico engloba: 1) Abastecimento de água potável; 2) Esgotamento sanitário; 3) Limpeza urbana e manejo de resíduos sólidos; 4) Drenagem e manejo de águas pluviais urbanas."
)
q.options.build(content: "Água potável, esgotamento sanitário, resíduos sólidos e drenagem de águas pluviais.", is_correct: true)
q.options.build(content: "Energia elétrica, asfalto, iluminação pública e telefonia celular.", is_correct: false)
q.options.build(content: "Controle de pragas, vacinação animal, reflorestamento e transporte público.", is_correct: false)
q.options.build(content: "Apenas fornecimento de água encanada e coleta de lixo hospitalar.", is_correct: false)
q.save!

# -------------------------------------------------------------
# NÍVEL 4: PROTEÇÃO FLORESTAL E ESPAÇOS PROTEGIDOS
# -------------------------------------------------------------
level_4 = Level.create!(
  name: "Proteção Florestal e Espaços Protegidos",
  description: "O Código Florestal (Lei 12.651/12), Áreas de Preservação Permanente (APP), Reserva Legal e o SNUC.",
  icon: "🌳"
)

# Tema 4.1
theme_4_1 = level_4.themes.create!(
  name: "Código Florestal (APP e Reserva Legal)",
  description: "Diferenças conceituais e regimes de preservação de margens de rios, topos de morro e percentuais de vegetação nativa.",
  icon: "🌲"
)

q = theme_4_1.questions.build(
  statement: "Qual a diferença conceitual fundamental entre Área de Preservação Permanente (APP) e Reserva Legal (RL)?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "A APP visa preservar funções ambientais específicas (margens de rios, encostas, topos de morro) e é intocável, enquanto a RL é uma porcentagem do imóvel rural destinada ao uso sustentável dos recursos florestais."
)
q.options.build(content: "A APP protege áreas frágeis por função ecológica específica; a RL é um percentual do imóvel rural para uso econômico sustentável.", is_correct: true)
q.options.build(content: "APP só existe em terras públicas e Reserva Legal em terras indígenas.", is_correct: false)
q.options.build(content: "A Reserva Legal permite o desmatamento total com plantio de eucalipto sem plano de manejo.", is_correct: false)
q.options.build(content: "Não há diferença, são termos sinônimos utilizados em biomas diferentes.", is_correct: false)
q.save!

q = theme_4_1.questions.build(
  statement: "Qual o percentual obrigatório de Reserva Legal exigido para um imóvel rural localizado em área de floresta na Amazônia Legal?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "De acordo com o Código Florestal (Art. 12, I, a), imóveis em áreas de floresta na Amazônia Legal devem manter no mínimo 80% de Reserva Legal."
)
q.options.build(content: "80% da área do imóvel rural.", is_correct: true)
q.options.build(content: "20% da área do imóvel rural.", is_correct: false)
q.options.build(content: "35% da área do imóvel rural.", is_correct: false)
q.options.build(content: "50% da área do imóvel rural.", is_correct: false)
q.save!

# Tema 4.2
theme_4_2 = level_4.themes.create!(
  name: "CAR e Regularização Ambiental",
  description: "O Cadastro Ambiental Rural (CAR) e o Programa de Regularização Ambiental (PRA).",
  icon: "🚜"
)

q = theme_4_2.questions.build(
  statement: "O Cadastro Ambiental Rural (CAR) é obrigatório para quais tipos de imóveis rurais no Brasil?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O CAR é um registro público eletrônico nacional obrigatório para TODOS os imóveis rurais do país, sejam públicos, privados, assentamentos ou pequenas propriedades."
)
q.options.build(content: "Obrigatório para todos os imóveis rurais (públicos e privados).", is_correct: true)
q.options.build(content: "Obrigatório apenas para propriedades com mais de 10.000 hectares.", is_correct: false)
q.options.build(content: "Facultativo e voluntário para produtores de soja e gado.", is_correct: false)
q.options.build(content: "Exclusivo para unidades de conservação administradas pelo ICMBio.", is_correct: false)
q.save!

q = theme_4_2.questions.build(
  statement: "O que acontece com o proprietário que adere ao Programa de Regularização Ambiental (PRA) para recompor passivos florestais?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Enquanto cumpre os compromissos do termo de adesão ao PRA para recompor a vegetação, as multas e sanções administrativas ficam suspensas e podem ser convertidas."
)
q.options.build(content: "As sanções e multas por desmatamento pretérito ficam suspensas durante o cumprimento do termo.", is_correct: true)
q.options.build(content: "O proprietário perde a posse da terra automaticamente em favor da União.", is_correct: false)
q.options.build(content: "O imóvel é interditado para qualquer tipo de produção por 50 anos.", is_correct: false)
q.options.build(content: "O proprietário é obrigado a pagar o valor da terra em títulos da dívida agrária.", is_correct: false)
q.save!

# Tema 4.3
theme_4_3 = level_4.themes.create!(
  name: "Sistema de Unidades de Conservação (SNUC)",
  description: "Grupos de Proteção Integral e Uso Sustentável segundo a Lei 9.985/2000.",
  icon: "🏞️"
)

q = theme_4_3.questions.build(
  statement: "Qual é a principal distinção entre Unidades de Proteção Integral e Unidades de Uso Sustentável no SNUC?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Unidades de Proteção Integral admitem apenas o uso indireto dos recursos naturais (pesquisa, turismo ecológico), enquanto as de Uso Sustentável compatibilizam conservação e exploração sustentável."
)
q.options.build(content: "Proteção Integral admite apenas uso indireto; Uso Sustentável permite exploração direta e manejada dos recursos.", is_correct: true)
q.options.build(content: "Proteção Integral permite mineração e agronegócio; Uso Sustentável proíbe presença humana.", is_correct: false)
q.options.build(content: "Uso Sustentável é administrado por ONGs internacionais e Proteção Integral pela Polícia Federal.", is_correct: false)
q.options.build(content: "Não há distinção, ambas possuem regras idênticas de zoneamento.", is_correct: false)
q.save!

q = theme_4_3.questions.build(
  statement: "Qual das seguintes categorias pertence ao grupo de Proteção Integral?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Parques Nacionais, Estações Ecológicas, Reservas Biológicas, Monumentos Naturais e Refúgios de Vida Silvestre são Unidades de Proteção Integral."
)
q.options.build(content: "Parque Nacional (PARNA).", is_correct: true)
q.options.build(content: "Área de Proteção Ambiental (APA).", is_correct: false)
q.options.build(content: "Floresta Nacional (FLONA).", is_correct: false)
q.options.build(content: "Reserva Extrativista (RESEX).", is_correct: false)
q.save!

# -------------------------------------------------------------
# NÍVEL 5: CRIMES AMBIENTAIS E RESPONSABILIDADE
# -------------------------------------------------------------
level_5 = Level.create!(
  name: "Crimes Ambientais e Responsabilidade",
  description: "A tríplice responsabilidade (civil, administrativa e penal), Lei de Crimes Ambientais (Lei 9.605/98) e Ação Civil Pública.",
  icon: "⚖️"
)

# Tema 5.1
theme_5_1 = level_5.themes.create!(
  name: "A Tríplice Responsabilidade Ambiental",
  description: "A cumulação independente das esferas civil (objetiva), administrativa e penal ambiental.",
  icon: "⚖️"
)

q = theme_5_1.questions.build(
  statement: "Um mesmo ato de degradação ambiental pode gerar responsabilização cumulativa em quais esferas jurídicas?",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O Art. 225, § 3º da CF/88 estabelece a tríplice responsabilidade cumulativa e independente: penal, administrativa e civil (obrigação de reparar o dano)."
)
q.options.build(content: "Nas três esferas de forma autônoma e cumulativa: Civil, Administrativa e Penal.", is_correct: true)
q.options.build(content: "Apenas em uma esfera por vez, sendo vedada qualquer cumulação pelo princípio do bis in idem.", is_correct: false)
q.options.build(content: "Apenas na esfera administrativa se houver pagamento da multa.", is_correct: false)
q.options.build(content: "Apenas na esfera penal se houver dolo comprovado do infrator.", is_correct: false)
q.save!

q = theme_5_1.questions.build(
  statement: "No Direito Ambiental brasileiro, a responsabilidade civil por dano ambiental adota qual teoria?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Adota-se a Teoria da Responsabilidade Civil Objetiva fundamentada no Risco Integral (Art. 14, § 1º da Lei 6.938/81 e jurisprudência pacífica do STJ), não admitindo excludentes como caso fortuito ou força maior."
)
q.options.build(content: "Responsabilidade Civil Objetiva sob a modalidade do Risco Integral (sem necessidade de culpa).", is_correct: true)
q.options.build(content: "Responsabilidade Civil Subjetiva com presunção de boa-fé do poluidor.", is_correct: false)
q.options.build(content: "Responsabilidade Subsidiária condicionada à insolvência do Estado.", is_correct: false)
q.options.build(content: "Responsabilidade Contratual estrita com cláusula de tolerância de 10%.", is_correct: false)
q.save!

# Tema 5.2
theme_5_2 = level_5.themes.create!(
  name: "Crimes contra a Fauna e Flora",
  description: "Principais tipos penais previstos na Lei Federal 9.605/98 referentes a animais silvestres e desmatamentos.",
  icon: "🐾"
)

q = theme_5_2.questions.build(
  statement: "A pessoa jurídica (empresa) pode ser responsabilizada penalmente por crimes ambientais no Brasil?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Sim! A Constituição Federal (Art. 225, § 3º) e a Lei 9.605/98 (Art. 3º) consagram expressamente a responsabilidade penal da pessoa jurídica em crimes ambientais."
)
q.options.build(content: "Sim, a CF/88 e a Lei 9.605/98 admitem a responsabilização penal da pessoa jurídica.", is_correct: true)
q.options.build(content: "Não, apenas pessoas físicas podem cometer crimes e sofrer sanções penais.", is_correct: false)
q.options.build(content: "Apenas se a empresa for estatal ou sociedade de economia mista.", is_correct: false)
q.options.build(content: "Apenas se todos os sócios confessarem a prática do ato ilícito.", is_correct: false)
q.save!

q = theme_5_2.questions.build(
  statement: "Matar, perseguir, caçar, apanhar ou utilizar espécimes da fauna silvestre sem a devida permissão ou autoridade competente configura:",
  difficulty: :easy,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Trata-se de crime contra a fauna previsto no Art. 29 da Lei 9.605/98, sujeito a pena de detenção de seis meses a um ano, além de multa."
)
q.options.build(content: "Crime contra a fauna tipificado na Lei de Crimes Ambientais.", is_correct: true)
q.options.build(content: "Mera infração contratual desprovida de sanção penal.", is_correct: false)
q.options.build(content: "Exercício regular de direito tradicional de caça livre.", is_correct: false)
q.options.build(content: "Crime inafiançável e imprescritível equiparado a terrorismo.", is_correct: false)
q.save!

# Tema 5.3
theme_5_3 = level_5.themes.create!(
  name: "Crimes de Poluição e Agrotóxicos",
  description: "Condutas de causar poluição de qualquer natureza que resulte ou possa resultar em danos à saúde humana ou mortandade de animais.",
  icon: "🏭"
)

q = theme_5_3.questions.build(
  statement: "O crime de poluição (Art. 54 da Lei 9.605/98) pune a conduta de causar poluição em níveis tais que resultem ou possam resultar em:",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O tipo penal pune a poluição que resulte ou possa resultar em danos à saúde humana, mortandade de animais ou destruição significativa da flora."
)
q.options.build(content: "Danos à saúde humana, mortandade de animais ou destruição significativa da flora.", is_correct: true)
q.options.build(content: "Prejuízos exclusivamente comerciais entre empresas concorrentes.", is_correct: false)
q.options.build(content: "Desconforto visual passageiro sem qualquer risco biológico.", is_correct: false)
q.options.build(content: "Variação climática sazonal natural de temperatura.", is_correct: false)
q.save!

q = theme_5_3.questions.build(
  statement: "Qual das condutas abaixo NÃO caracteriza crime previsto na Lei de Crimes Ambientais?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O cultivo de hortaliças orgânicas em área urbana de acordo com as normas sanitárias e ambientais é atividade lícita e sustentável."
)
q.options.build(content: "Cultivo de horta orgânica comunitária de acordo com as normas municipais.", is_correct: true)
q.options.build(content: "Disseminar doença ou praga que possa causar dano à agricultura ou à flora.", is_correct: false)
q.options.build(content: "Produzir, transportar ou estocar substância tóxica em desacordo com as exigências legais.", is_correct: false)
q.options.build(content: "Obstar ou dificultar a ação fiscalizadora do Poder Público no trato de questões ambientais.", is_correct: false)
q.save!

# Tema 5.4
theme_5_4 = level_5.themes.create!(
  name: "Ação Civil Pública e Tutela Coletiva",
  description: "Instrumentos processuais para a defesa dos direitos difusos e coletivos ambientais (Lei 7.347/85).",
  icon: "📢"
)

q = theme_5_4.questions.build(
  statement: "Quem possui legitimidade ativa para propor Ação Civil Pública (ACP) em defesa do meio ambiente?",
  difficulty: :medium,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "Conforme o Art. 5º da Lei 7.347/85, são legitimados: Ministério Público, Defensoria Pública, União, Estados, Municípios, Autarquias, Empresas Públicas e Associações constituídas há pelo menos 1 ano com pertinência temática."
)
q.options.build(content: "Ministério Público, Defensoria Pública, Entes Federativos e Associações civis com pertinência temática.", is_correct: true)
q.options.build(content: "Exclusivamente o Presidente da República e governadores de estado.", is_correct: false)
q.options.build(content: "Apenas cidadãos eleitores com mais de 70 anos.", is_correct: false)
q.options.build(content: "Exclusivamente tribunais internacionais de arbitragem.", is_correct: false)
q.save!

q = theme_5_4.questions.build(
  statement: "O que é o Termo de Ajustamento de Conduta (TAC) firmado pelos órgãos públicos legitimados com o poluidor?",
  difficulty: :hard,
  youtube_link: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  feedback_article: "O TAC é um título executivo extrajudicial pelo qual o causador do dano se compromete a ajustar sua conduta às exigências legais, sob pena de cominações."
)
q.options.build(content: "Um título executivo extrajudicial no qual o causador do dano assume compromissos de reparação e conformidade legal.", is_correct: true)
q.options.build(content: "Um perdão judicial irrestrito que anula a necessidade de reparação ecológica.", is_correct: false)
q.options.build(content: "Um contrato de compra e venda de terras públicas florestais.", is_correct: false)
q.options.build(content: "Um decreto executivo que autoriza o fechamento permanente de indústrias sem direito de defesa.", is_correct: false)
q.save!

puts "== Seed finalizado com Sucesso! =="
puts "-> Níveis criados: #{Level.count}"
puts "-> Temas criados: #{Theme.count}"
puts "-> Questões criadas: #{Question.count}"
puts "-> Opções criadas: #{Option.count}"

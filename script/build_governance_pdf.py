"""Build the governance dossier from the current pt-BR legal text and project records.

Usage: python3 script/build_governance_pdf.py tmp/pdfs/legal_documents.json
Requires ReportLab and Liberation Serif. No network or application database access.
"""
import json
import sys
from html import escape
from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_JUSTIFY
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'output/pdf/game-qta-governanca-e-privacidade.pdf'
DATA = json.loads(Path(sys.argv[1]).read_text())
FONT = Path('/usr/share/fonts/liberation-serif-fonts')
pdfmetrics.registerFont(TTFont('Document', str(FONT / 'LiberationSerif-Regular.ttf')))
pdfmetrics.registerFont(TTFont('Document-Bold', str(FONT / 'LiberationSerif-Bold.ttf')))
pdfmetrics.registerFontFamily('Document', normal='Document', bold='Document-Bold', italic='Document', boldItalic='Document-Bold')
styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='BodyQTA', fontName='Document', fontSize=11, leading=16, textColor=colors.black, alignment=TA_JUSTIFY, spaceAfter=8))
styles.add(ParagraphStyle(name='H1QTA', fontName='Document-Bold', fontSize=16, leading=21, textColor=colors.black, spaceBefore=8, spaceAfter=12, keepWithNext=True))
styles.add(ParagraphStyle(name='H2QTA', fontName='Document-Bold', fontSize=12, leading=17, textColor=colors.black, spaceBefore=10, spaceAfter=7, keepWithNext=True))
styles.add(ParagraphStyle(name='SmallQTA', parent=styles['BodyQTA'], fontSize=9.5, leading=13, alignment=TA_LEFT))
styles.add(ParagraphStyle(name='CoverQTA', parent=styles['H1QTA'], fontSize=24, leading=30, alignment=TA_CENTER, spaceAfter=20))
styles.add(ParagraphStyle(name='CoverLabelQTA', parent=styles['SmallQTA'], alignment=TA_CENTER, spaceAfter=12))
styles.add(ParagraphStyle(name='CellQTA', parent=styles['BodyQTA'], fontSize=9.5, leading=13, alignment=TA_LEFT, spaceAfter=0))
story = []


def clean(text):
    return str(text).replace('\u2014', '-').replace('\u2013', '-').replace('\u2011', '-')


def p(text, style='BodyQTA'):
    return Paragraph(escape(clean(text)), styles[style])


def para(text, style='BodyQTA'):
    story.append(p(text, style))


def heading(text, level=1):
    para(text, 'H1QTA' if level == 1 else 'H2QTA')


def bullet(text):
    story.append(Paragraph('• ' + escape(clean(text)), styles['BodyQTA']))


def link(label, url):
    story.append(Paragraph(f'<link href="{escape(url, quote=True)}" color="#000000"><u>{escape(clean(label))}</u></link>', styles['SmallQTA']))


def table(rows, widths):
    cells = [[p(cell, 'CellQTA') for cell in row] for row in rows]
    cells[0] = [Paragraph('<b>' + escape(clean(cell)) + '</b>', styles['CellQTA']) for cell in rows[0]]
    t = Table(cells, colWidths=widths, repeatRows=1, hAlign='LEFT')
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#F2F2F2')),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('FONTNAME', (0, 0), (-1, 0), 'Document-Bold'),
        ('LEFTPADDING', (0, 0), (-1, -1), 8), ('RIGHTPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 8), ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('LINEBELOW', (0, 0), (-1, -1), 0.4, colors.black),
    ]))
    story.append(t)
    story.append(Spacer(1, 10))


def page(canvas, doc):
    canvas.saveState()
    w, h = A4
    canvas.setStrokeColor(colors.black)
    canvas.line(25 * mm, h - 18 * mm, w - 25 * mm, h - 18 * mm)
    canvas.setFillColor(colors.black)
    canvas.setFont('Document', 8)
    canvas.drawString(25 * mm, h - 14 * mm, 'GAME QTA  |  GOVERNANÇA E PRIVACIDADE')
    canvas.drawString(25 * mm, 14 * mm, '03/11/2026  |  Minutas e registro de implementação')
    canvas.drawRightString(w - 25 * mm, 14 * mm, str(doc.page))
    canvas.restoreState()


story.append(Spacer(1, 28 * mm))
para('GAME QTA', 'CoverLabelQTA')
para('Governança, termos\ne privacidade'.replace('\n', ' '), 'CoverQTA')
para('Dossiê para o responsável e a equipe do projeto', 'H2QTA')
para('Emissão: 03/11/2026. Documentos do site: ' + DATA['shared']['version'] + '.')
para('Responsável informado: ' + DATA['shared']['contact_name'])
para('Contato público de privacidade: ' + DATA['shared']['contact_email'])
story.append(Spacer(1, 10 * mm))
para('Estado da entrega', 'H2QTA')
para('Cadastro direto preservado, com os campos de idade, escolaridade e cidade. Termos, política, aceite versionado, perfil e exclusão já possuem implementação. A entrega também protege cookies, bloqueia conexões opcionais, melhora acessibilidade e publica o contato do responsável.')
para('Este dossiê reúne decisões de produto, funcionamento implementado, minutas integrais e pendências. Não é parecer jurídico, aprovação de pesquisa ou certificação de conformidade. As avaliações de bases legais e de proteção de menores não estão encerradas.')
story.append(Spacer(1, 8 * mm))
para('A UESC não foi indicada como responsável formal pela operação do jogo. A possibilidade de pesquisa futura pela instituição será avaliada separadamente. Papéis jurídicos dependem da atuação efetiva das partes.', 'SmallQTA')
story.append(PageBreak())

heading('1. Decisões e experiência de uso')
para('O visitante continua preenchendo o cadastro atual e registrando o aceite dos Termos e a ciência da Política. Não foi adicionada etapa de autorização externa, área de responsáveis, coleta de documentos ou formulário específico por idade. Os limites de idade que já existiam são preservados; esse campo é autodeclarado.')
table([
    ['Item', 'Comportamento implementado'],
    ['Idade, escolaridade e cidade', 'Campos e valores preservados. Cidade e escolaridade continuam opcionais e podem ser removidas pelo perfil. A necessidade atual dos dados deve ser justificada.'],
    ['Ranking', 'Código aleatório gerado pelo sistema substitui nome completo e e-mail. Pontos, tempo e ordem da classificação são preservados. O código ainda pode ser associado à conta pela administração.'],
    ['Aceite', 'Registro de horário, versões, revisão e cópia dos textos apresentados. Contas antigas não recebem aceite retroativo. Mudança de texto exige nova manifestação antes do jogo.'],
    ['Direitos', 'Perfil e exclusão continuam disponíveis mesmo sem novo aceite. O contato público complementa casos de representantes, falta de acesso e outros direitos.'],
    ['Tempo e resposta', 'Escolha de 1 a 10 vezes o tempo antes de revelar a questão. Pontos iguais, tempo efetivo no desempate. Alternativa só é enviada pelo botão de confirmação.'],
    ['Segurança', 'Senha verificada com BCrypt no servidor; edição exige senha atual e exclusão exige confirmação adicional. Páginas privadas recebem no-store; snapshots Turbo são desativados e o cache é limpo ao sair.'],
], [40 * mm, 120 * mm])
heading('2. Dados, finalidades e pesquisa', 1)
para('A operação educativa e eventual pesquisa são finalidades distintas. O cadastro não concede autorização geral para qualquer estudo. O professor informou interesse em idade, escolaridade e cidade para possível pesquisa futura, mas as análises ainda não foram definidas.')
para('A hipótese de legítimo interesse está em avaliação para conta, progresso e segurança. A avaliação considera o uso real de cada dado e os direitos dos menores. Não há conclusão favorável automática, especialmente para os campos demográficos e guarda sem prazo definido.')
para('Uma pesquisa ou banco futuro exigirá finalidade delimitada, governança, acesso, retenção, base aplicável e observância dos procedimentos éticos pertinentes. Dados codificados não são necessariamente anônimos. Exportação administrativa existente não constitui autorização científica.')
story.append(PageBreak())

heading('3. Atendimento e exercício de direitos')
para('Responsável: ' + DATA['shared']['contact_name'] + '. Canal: ' + DATA['shared']['contact_email'] + '.')
for item in [
    'O site apresenta um link de e-mail. O visitante usa seu próprio serviço de correio; o site não envia a mensagem, não comprova a entrega e não emite protocolo.',
    'A equipe deve monitorar a caixa, confirmar recebimento, registrar a demanda com acesso restrito e responder segundo os prazos legais aplicáveis ao direito solicitado.',
    'Identidade e eventual representação devem ser verificadas de modo proporcional. Não solicitar senha nem cópia de documento como regra geral. A autorização da escola não substitui automaticamente a do responsável legal.',
    'Pedidos sobre acesso, correção, exclusão, oposição, informações, moderação ou proteção de menores podem ser encaminhados pelo mesmo contato. Eventual impossibilidade deve ser explicada.',
    'Registros do atendimento também são dados pessoais: precisam de acesso restrito e regra de guarda definida pelo responsável.'
]:
    bullet(item)
heading('Autoatendimento no perfil', 2)
para('O estudante pode consultar e editar seus dados em /perfil. A edição verifica a senha atual. A exclusão exige senha e confirmação, remove cadastro, sessões, tentativas, respostas, ranking e aceites da aplicação ativa. Conteúdo didático e dados dos demais participantes são preservados. Jobs pendentes não devem restaurar um ranking excluído.')
para('A exclusão na aplicação não apaga automaticamente logs, backups, e-mails recebidos ou cópias de relatórios já exportadas. Os procedimentos e prazos dessas cópias permanecem pendentes. Não se promete eliminação universal imediata.')
heading('Cookies e acessibilidade implementados', 2)
para('Cookies próprios: _qta_rails8_session (navegação, até 12h após uso), user_session_id (estudante) e session_id (administração). O acesso autenticado vence 12h após login também no servidor. HttpOnly e SameSite=Lax; Secure e HTTPS em produção. Sair revoga a sessão. Esse limite de acesso não define retenção de registros no banco.')
para('Fontes do dispositivo substituem Google Fonts. Vídeos começam sem iframe ou conexão externa. Carregar este vídeo ativa somente aquele player; Continuar sem vídeo mantém bloqueio, e Desativar vídeo externo remove o iframe. A escolha não é salva. Navegar ou recarregar exige nova escolha. O fornecedor recebe dados após ativação; revogar não desfaz dados já enviados.')
para('Foco visível, skip link, diálogos nativos com Escape, erros associados aos campos, preferência de reduzir movimento e confirmação explícita pelo botão Confirmar resposta foram implementados. O relógio anuncia apenas um aviso próximo do fim, sem interromper leitura a cada segundo. A página /acessibilidade explica esses recursos e os limites conhecidos.')
para('Validação local: 105 testes de aplicação e 30 de navegador passaram. Brakeman sem alertas; bundler-audit sem vulnerabilidades conhecidas. Axe verificou as telas públicas, estudantis e administrativas. Resultados automáticos não são certificação jurídica ou WCAG. Vídeos, leitor de tela humano e implantação definitiva exigem avaliação complementar.')
heading('4. Pontos que ainda precisam de decisão', 1)
table([
    ['Tema', 'Pendência'],
    ['Base legal e menores', 'Concluir avaliação por finalidade, necessidade e riscos, com decisão do responsável. Definir medidas de supervisão/proteção aplicáveis antes de declarar adequação integral.'],
    ['Infraestrutura e guarda', 'Definir hospedagem, operadores, locais de tratamento e retenção de contas, logs, aceites, backups e exportações. HTTPS está configurado, mas requer conferência do proxy e domínio definitivo.'],
    ['Operação de atendimento', 'Confirmar monitoramento da caixa, substituto, procedimento para contas sem acesso e verificação de representantes.'],
    ['Cookies e terceiros', 'Controles técnicos implementados e inventário disponível. Confirmar adequação dos vídeos ao público infantil e requisitos do fornecedor; não afirmar ausência de tratamento externo após ativação.'],
    ['Acessibilidade', 'Testes automáticos e de teclado executados. Conferir legendas, transcrições, alternativas e leitores de tela com avaliação humana. Sem declaração integral WCAG ou de PDF acessível/tagueado.'],
    ['Pesquisa', 'Estudo, análises, instituição responsável e requisitos éticos/bases aplicáveis ainda por definir.'],
], [40 * mm, 120 * mm])
story.append(PageBreak())

for number, key in [(5, 'terms'), (6, 'privacy')]:
    document = DATA[key]
    heading(f'{number}. {document["title"]} - texto integral')
    para('Versão: ' + DATA['shared']['version'] + ' | Atualização: 03/11/2026', 'SmallQTA')
    notice = Table([[p(DATA['shared']['draft_title'] + '. ' + DATA['shared']['draft_notice'], 'SmallQTA')]], colWidths=[160 * mm])
    notice.setStyle(TableStyle([('BACKGROUND', (0, 0), (-1, -1), colors.white), ('BOX', (0, 0), (-1, -1), 0.5, colors.black), ('LEFTPADDING', (0, 0), (-1, -1), 10), ('RIGHTPADDING', (0, 0), (-1, -1), 10), ('TOPPADDING', (0, 0), (-1, -1), 10), ('BOTTOMPADDING', (0, 0), (-1, -1), 10)]))
    story.append(notice)
    story.append(Spacer(1, 12))
    para(document['subtitle'])
    para(document['summary'])
    for section in document['sections'].values():
        section_start = len(story)
        heading(section['title'], 2)
        for paragraph in section.get('paragraphs', []):
            para(paragraph)
        for item in section.get('items', []):
            bullet(item)
        for reference in section.get('links', []):
            link(reference['label'], reference['url'])
        if section is list(document['sections'].values())[-1]:
            heading('Contato de privacidade', 2)
            para(DATA['shared']['contact_name'] + ' | ' + DATA['shared']['contact_email'])
        section_content = story[section_start:]
        del story[section_start:]
        story.append(KeepTogether(section_content))
    story.append(PageBreak())

heading('7. Referências e manutenção')
para('As minutas integrais foram extraídas de config/locales/pt-BR/legal.yml. Os requisitos e resultados ficam no diretório ai-sdd/prd-governanca-juridica-lgpd-acessibilidade. A avaliação preliminar por finalidade e o procedimento de atendimento estão nos documentos desse diretório.')
for label, url in [
    ('LGPD - texto compilado na Câmara dos Deputados', 'https://www2.camara.leg.br/legin/fed/lei/2018/lei-13709-14-agosto-2018-787077-normaatualizada-pl.html'),
    ('ANPD - Enunciado 1/2023 sobre dados de crianças e adolescentes', 'https://bibliotecadigital.mj.gov.br/bitstream/1/10215/2/Enunciado_ANPD_2023_1.html'),
    ('ANPD - Guia de legítimo interesse', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_legitimo_interesse.pdf'),
    ('ANPD - ECA Digital', 'https://www.gov.br/anpd/pt-br/assuntos/eca-digital'),
    ('ANPD - Guia de cookies', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_orientativo_cookies_e_protecao_de_dados_pessoais'),
    ('W3C - WCAG 2.1', 'https://www.w3.org/TR/WCAG21/'),
    ('ANPD - Guia de fins acadêmicos e pesquisas', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/web-guia-anpd-tratamento-de-dados-para-fins-academicos.pdf'),
]:
    link(label, url)
    story.append(Spacer(1, 7))
heading('Atualização e responsabilidade', 2)
para('Revisar os documentos quando houver mudança de finalidade, responsável, infraestrutura, dados, integrações ou controles. A versão publicada no aplicativo pode evoluir após esta emissão; conferir data e versão antes de reutilizar o PDF. Os testes confirmam comportamento técnico, não certificam validade jurídica ou cumprimento operacional.')
para('Antes da disponibilização definitiva, o responsável deve concluir as decisões pendentes e providenciar a validação cabível. A existência deste documento não indica aprovação da UESC, de comitê de ética ou da ANPD.')

OUT.parent.mkdir(parents=True, exist_ok=True)
doc = SimpleDocTemplate(str(OUT), pagesize=A4, leftMargin=25 * mm, rightMargin=25 * mm, topMargin=25 * mm, bottomMargin=25 * mm, title='Game QTA - Governança, termos e privacidade', author=DATA['shared']['contact_name'])
doc.build(story, onFirstPage=page, onLaterPages=page)
print(OUT)

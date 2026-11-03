"""Build the governance dossier from the current pt-BR legal text and project records.

Usage: python3 script/build_governance_pdf.py tmp/pdfs/legal_documents.json
Requires ReportLab and DejaVu Sans. No network or application database access.
"""
import json
import sys
from html import escape
from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'output/pdf/game-qta-governanca-e-privacidade.pdf'
DATA = json.loads(Path(sys.argv[1]).read_text())
FONT = Path('/usr/share/fonts/dejavu-sans-fonts')
pdfmetrics.registerFont(TTFont('DejaVu', str(FONT / 'DejaVuSans.ttf')))
pdfmetrics.registerFont(TTFont('DejaVu-Bold', str(FONT / 'DejaVuSans-Bold.ttf')))
pdfmetrics.registerFontFamily('DejaVu', normal='DejaVu', bold='DejaVu-Bold', italic='DejaVu', boldItalic='DejaVu-Bold')
INK = colors.HexColor('#163B35')
GREEN = colors.HexColor('#065F46')
MUTED = colors.HexColor('#475569')
styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='BodyQTA', fontName='DejaVu', fontSize=9.3, leading=14, textColor=colors.HexColor('#24332F'), spaceAfter=8))
styles.add(ParagraphStyle(name='H1QTA', fontName='DejaVu-Bold', fontSize=20, leading=26, textColor=INK, spaceBefore=6, spaceAfter=15, keepWithNext=True))
styles.add(ParagraphStyle(name='H2QTA', fontName='DejaVu-Bold', fontSize=12, leading=17, textColor=GREEN, spaceBefore=11, spaceAfter=7, keepWithNext=True))
styles.add(ParagraphStyle(name='SmallQTA', parent=styles['BodyQTA'], fontSize=8, leading=12, textColor=MUTED))
styles.add(ParagraphStyle(name='CoverQTA', parent=styles['H1QTA'], fontSize=31, leading=39, spaceAfter=20))
styles.add(ParagraphStyle(name='CellQTA', parent=styles['BodyQTA'], fontSize=8.5, leading=12.5, spaceAfter=0))
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
    story.append(Paragraph(f'<link href="{escape(url, quote=True)}" color="#065F46"><u>{escape(clean(label))}</u></link>', styles['SmallQTA']))


def table(rows, widths):
    cells = [[p(cell, 'CellQTA') for cell in row] for row in rows]
    t = Table(cells, colWidths=widths, repeatRows=1, hAlign='LEFT')
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#D1FAE5')),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('LEFTPADDING', (0, 0), (-1, -1), 8), ('RIGHTPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 8), ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('LINEBELOW', (0, 0), (-1, -1), 0.4, colors.HexColor('#CBD5E1')),
    ]))
    story.append(t)
    story.append(Spacer(1, 10))


def page(canvas, doc):
    canvas.saveState()
    w, h = A4
    canvas.setStrokeColor(colors.HexColor('#C5DAD2'))
    canvas.line(21 * mm, h - 18 * mm, w - 21 * mm, h - 18 * mm)
    canvas.setFillColor(MUTED)
    canvas.setFont('DejaVu', 7)
    canvas.drawString(21 * mm, h - 14 * mm, 'GAME QTA  |  GOVERNANÇA E PRIVACIDADE')
    canvas.drawString(21 * mm, 14 * mm, '03/11/2026  |  Minutas e registro de implementação')
    canvas.drawRightString(w - 21 * mm, 14 * mm, str(doc.page))
    canvas.restoreState()


story.append(Spacer(1, 28 * mm))
para('GAME QTA', 'SmallQTA')
para('Governança, termos\ne privacidade'.replace('\n', ' '), 'CoverQTA')
para('Dossiê para o responsável e a equipe do projeto', 'H2QTA')
para('Emissão: 03/11/2026. Documentos do site: ' + DATA['shared']['version'] + '.')
para('Responsável informado: ' + DATA['shared']['contact_name'])
para('Contato público de privacidade: ' + DATA['shared']['contact_email'])
story.append(Spacer(1, 10 * mm))
para('Estado da entrega', 'H2QTA')
para('Cadastro direto preservado, com os campos de idade, escolaridade e cidade. Termos, política, aceite versionado, perfil e exclusão já possuem implementação. Esta atualização reduz a exposição no ranking e publica o contato do responsável.')
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
    ['Segurança', 'Senha verificada com BCrypt no servidor; edição exige senha atual e exclusão exige confirmação adicional. Páginas estudantis e exportações administrativas recebem no-store.'],
], [42 * mm, 126 * mm])
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
heading('4. Pontos que ainda precisam de decisão', 1)
table([
    ['Tema', 'Pendência'],
    ['Base legal e menores', 'Concluir avaliação por finalidade, necessidade e riscos, com decisão do responsável. Definir medidas de supervisão/proteção aplicáveis antes de declarar adequação integral.'],
    ['Infraestrutura e guarda', 'Definir hospedagem, operadores, locais de tratamento, transporte HTTPS e retenção de contas, logs, aceites, backups e exportações.'],
    ['Operação de atendimento', 'Confirmar monitoramento da caixa, substituto, procedimento para contas sem acesso e verificação de representantes.'],
    ['Cookies e terceiros', 'Auditoria completa e implementação do tópico 3 pendentes. Telas existentes ainda usam Google Fonts e vídeos YouTube; não afirmar que toda navegação usa somente tecnologias essenciais.'],
    ['Acessibilidade', 'Auditoria abrangente do tópico 4 pendente: contraste, teclado, leitor de tela, cronômetro, modais, alternativas e vídeos. Sem declaração integral WCAG.'],
    ['Pesquisa', 'Estudo, análises, instituição responsável e requisitos éticos/bases aplicáveis ainda por definir.'],
], [42 * mm, 126 * mm])
story.append(PageBreak())

for number, key in [(5, 'terms'), (6, 'privacy')]:
    document = DATA[key]
    heading(f'{number}. {document["title"]} - texto integral')
    para('Versão: ' + DATA['shared']['version'] + ' | Atualização: 03/11/2026', 'SmallQTA')
    notice = Table([[p(DATA['shared']['draft_title'] + '. ' + DATA['shared']['draft_notice'], 'SmallQTA')]], colWidths=[168 * mm])
    notice.setStyle(TableStyle([('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#FFFBEB')), ('BOX', (0, 0), (-1, -1), 0.5, colors.HexColor('#A16207')), ('LEFTPADDING', (0, 0), (-1, -1), 10), ('RIGHTPADDING', (0, 0), (-1, -1), 10), ('TOPPADDING', (0, 0), (-1, -1), 10), ('BOTTOMPADDING', (0, 0), (-1, -1), 10)]))
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
    ('ANPD - Guia de fins acadêmicos e pesquisas', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/web-guia-anpd-tratamento-de-dados-para-fins-academicos.pdf'),
]:
    link(label, url)
    story.append(Spacer(1, 7))
heading('Atualização e responsabilidade', 2)
para('Revisar os documentos quando houver mudança de finalidade, responsável, infraestrutura, dados, integrações ou controles. A versão publicada no aplicativo pode evoluir após esta emissão; conferir data e versão antes de reutilizar o PDF. Os testes confirmam comportamento técnico, não certificam validade jurídica ou cumprimento operacional.')
para('Antes da disponibilização definitiva, o responsável deve concluir as decisões pendentes e providenciar a validação cabível. A existência deste documento não indica aprovação da UESC, de comitê de ética ou da ANPD.')

OUT.parent.mkdir(parents=True, exist_ok=True)
doc = SimpleDocTemplate(str(OUT), pagesize=A4, leftMargin=21 * mm, rightMargin=21 * mm, topMargin=25 * mm, bottomMargin=23 * mm, title='Game QTA - Governança, termos e privacidade', author=DATA['shared']['contact_name'])
doc.build(story, onFirstPage=page, onLaterPages=page)
print(OUT)

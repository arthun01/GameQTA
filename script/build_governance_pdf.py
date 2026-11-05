"""Build the governance manual and the complete current pt-BR legal documents.

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
    canvas.drawString(25 * mm, 14 * mm, 'Versão 1.0  |  04/11/2026')
    canvas.drawRightString(w - 25 * mm, 14 * mm, str(doc.page))
    canvas.restoreState()



def markdown_source(path):
    lines = path.read_text().splitlines()
    paragraph = []
    rows = []

    def flush_paragraph():
        if paragraph:
            para(' '.join(paragraph))
            paragraph.clear()

    def flush_table():
        if rows:
            count = len(rows[0])
            widths = [35 * mm, 65 * mm, 60 * mm] if count == 3 else [50 * mm, 110 * mm]
            table(rows, widths)
            rows.clear()

    for line in lines + ['']:
        line = line.strip()
        if line.startswith('|'):
            flush_paragraph()
            cells = [cell.strip() for cell in line.strip('|').split('|')]
            if not all(set(cell) <= set('-: ') for cell in cells):
                rows.append(cells)
        else:
            flush_table()
            if line.startswith('# '):
                continue
            elif line.startswith('## '):
                flush_paragraph()
                heading(line[3:])
            elif line.startswith('- '):
                flush_paragraph()
                bullet(line[2:])
            elif not line:
                flush_paragraph()
            else:
                paragraph.append(line)


story.append(Spacer(1, 30 * mm))
para('GAME QTA', 'CoverLabelQTA')
para('Governança e Privacidade', 'CoverQTA')
para('Manual de governança, Termos de Uso e Política de Privacidade', 'CoverLabelQTA')
story.append(Spacer(1, 12 * mm))
para('Versão ' + DATA['shared']['version'] + ' | Emissão: 04/11/2026', 'CoverLabelQTA')
para('Responsável: ' + DATA['shared']['contact_name'], 'CoverLabelQTA')
para('Contato: ' + DATA['shared']['contact_email'], 'CoverLabelQTA')
story.append(Spacer(1, 15 * mm))
para('Este documento consolida as regras da operação educativa do Game QTA, os direitos dos participantes e os procedimentos da administração. A versão é completa e reúne os textos públicos integrais ao final do manual.')
para('Os procedimentos de guarda, aviso, descarte e resposta a incidentes são regras de governança que devem ser executadas e verificadas. Sua formalização não declara automação já implantada, certificação jurídica ou autorização de pesquisa.', 'SmallQTA')
story.append(PageBreak())
heading('Organização do documento')
for item in [
    'Parte I - Manual de Governança: responsabilidades; finalidades e fundamentos; crianças e adolescentes; retenção e descarte; atendimento; segurança e incidentes; terceiros; acessibilidade; pesquisa e mudanças.',
    'Parte II - Termos de Uso: texto integral apresentado aos participantes.',
    'Parte III - Política de Privacidade: texto integral apresentado aos participantes.',
    'Parte IV - Referências normativas e orientações oficiais.'
]:
    bullet(item)
para('O manual orienta a equipe. Os termos e a política explicam as regras ao público. Todos devem ser lidos com a versão e a data desta emissão. Alterações relevantes exigem revisão coerente das informações apresentadas aos participantes.')
story.append(PageBreak())
heading('Parte I - Manual de Governança')
markdown_source(ROOT / 'ai-sdd/prd-governanca-juridica-lgpd-acessibilidade/governanca-privacidade.md')
story.append(PageBreak())

for part, key in [('Parte II', 'terms'), ('Parte III', 'privacy')]:
    document = DATA[key]
    heading(part + ' - ' + document['title'])
    para('Versão ' + DATA['shared']['version'] + ' | Atualização: 04/11/2026', 'SmallQTA')
    para(document['summary'])
    for section in document['sections'].values():
        heading(section['title'], 2)
        for item in section.get('items', []):
            bullet(item)
        for paragraph in section.get('paragraphs', []):
            para(paragraph)
        for reference in section.get('links', []):
            link(reference['label'], reference['url'])
    heading('Contato de privacidade', 2)
    para(DATA['shared']['contact_name'] + ' | ' + DATA['shared']['contact_email'])
    story.append(PageBreak())

heading('Parte IV - Referências')
para('Referências consultadas para a elaboração das regras. A menção a órgãos e instituições não representa aprovação ou certificação por eles. A manutenção deve considerar os textos normativos vigentes e as circunstâncias efetivas da operação.')
for label, url in [
    ('LGPD - Lei nº 13.709/2018, texto atualizado', 'https://www2.camara.leg.br/legin/fed/lei/2018/lei-13709-14-agosto-2018-787077-normaatualizada-pl.html'),
    ('ANPD - Tratamento de dados de crianças e adolescentes: Enunciado 1/2023', 'https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-divulga-enunciado-sobre-o-tratamento-de-dados-pessoais-de-criancas-e-adolescentes'),
    ('ANPD - Legítimo interesse: finalidade, necessidade e balanceamento', 'https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-lanca-guia-orientativo-sobre-legitimo-interesse'),
    ('ECA Digital - Lei nº 15.211/2025', 'https://www2.camara.leg.br/legin/fed/lei/2025/lei-15211-17-setembro-2025-797997-normaatualizada-pl.html'),
    ('ANPD - Orientações sobre o ECA Digital', 'https://www.gov.br/anpd/pt-br/assuntos/eca-digital'),
    ('ANPD - Regulamento de comunicação de incidentes: Resolução 15/2024', 'https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-aprova-o-regulamento-de-comunicacao-de-incidente-de-seguranca'),
    ('ANPD - Comunicação de incidente de segurança', 'https://www.gov.br/anpd/pt-br/canais_atendimento/agente-de-tratamento/comunicado-de-incidente-de-seguranca-cis'),
    ('ANPD - Direitos dos titulares', 'https://www.gov.br/anpd/pt-br/assuntos/titular-de-dados/direito-dos-titulares'),
    ('ANPD - Guia de cookies', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_orientativo_cookies_e_protecao_de_dados_pessoais'),
    ('ANPD - Tratamento para fins acadêmicos e pesquisas', 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/web-guia-anpd-tratamento-de-dados-para-fins-academicos.pdf'),
    ('W3C - WCAG 2.1', 'https://www.w3.org/TR/WCAG21/'),
]:
    link(label, url)
    story.append(Spacer(1, 8))

OUT.parent.mkdir(parents=True, exist_ok=True)
doc = SimpleDocTemplate(str(OUT), pagesize=A4, leftMargin=25 * mm, rightMargin=25 * mm, topMargin=25 * mm, bottomMargin=25 * mm, title='Game QTA - Governança e Privacidade - Versão 1.0', author=DATA['shared']['contact_name'])
doc.build(story, onFirstPage=page, onLaterPages=page)
print(OUT)

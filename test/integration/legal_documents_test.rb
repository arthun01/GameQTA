require "test_helper"

class LegalDocumentsTest < ActionDispatch::IntegrationTest
  test "documents are public and do not create accounts or authenticated sessions" do
    assert_no_difference [ "User.count", "Admin.count", "UserSession.count", "Session.count" ] do
      [ terms_path, privacy_policy_path ].each do |path|
        get path

        assert_response :success
        assert_select "html[lang='pt-BR']"
        assert_select "main article h1", count: 1
        assert_select "[data-legal-draft]", text: /Minuta — documento em elaboração/
        assert_select "[data-legal-version]", text: "0.2 — minuta"
        assert_select "time[datetime='2026-10-27']", text: "27/10/2026"
        assert_select "form", count: 0
        assert_select "a[href^='mailto:']", count: 0
        assert_select "iframe", count: 0
        assert_select "link[href*='fonts.googleapis.com']", count: 0
        assert_no_match(/translation missing|Translation missing/, response.body)
      end
    end
  end

  test "terms describe participation moderation and limits of the draft" do
    get terms_path

    assert_select "h1", "Termos de Uso"
    assert_select "#section-rules", text: /bloqueio encerra as sessões/
    assert_select "#section-participation", text: /não comprovam autorização de um responsável legal/
    assert_select "#section-closing", text: /não recebe nem protocola pedidos/
    assert_select "#section-changes", text: /não registra concordância automática/i
    assert_select "a[href=?]", privacy_policy_path
  end

  test "privacy describes actual data third parties and pending contact and retention" do
    get privacy_policy_path

    assert_select "h1", "Política de Privacidade"
    assert_select "#section-generated_data", text: /endereço IP/
    assert_select "#section-access", text: /exportações.*nome, e-mail, cidade, escolaridade/m
    assert_select "#section-cookies", text: /YouTube.*Google Fonts/m
    assert_select "#section-retention", text: /Ainda não foram definidos os prazos/
    assert_select "#section-rights", text: /corrigir.*revogar.*revisão/m
    assert_select "#section-requests", text: /O canal de privacidade ainda não foi definido/
    assert_select "a[href=?]", "https://www.gov.br/anpd/pt-br/assuntos/titular-de-dados/direito-dos-titulares"
    assert_select "a[href=?]", terms_path
  end

  test "section index points to existing unique sections in both documents" do
    [ terms_path, privacy_policy_path ].each do |path|
      get path

      ids = css_select("[id]").map { |element| element["id"] }
      assert_equal ids.uniq, ids

      css_select("nav[aria-labelledby='document-index-title'] a").each do |link|
        assert_includes ids, link["href"].delete_prefix("#")
      end
    end
  end

  test "public login and registration pages link to legal documents in a separate tab" do
    [ entrar_path, cadastrar_path, new_admin_session_path ].each do |path|
      get path

      assert_response :success
      assert_legal_links
    end
  end

  test "student can find documents without ending the authenticated session" do
    sign_in_as_user users(:student_one)
    get jornada_path

    assert_response :success
    assert_legal_links

    get privacy_policy_path
    assert_response :success

    get jornada_path
    assert_response :success
  end

  test "admin can find documents without ending the authenticated session" do
    sign_in_as admins(:one)
    get admin_root_path

    assert_response :success
    assert_legal_links

    get terms_path
    assert_response :success

    get admin_root_path
    assert_response :success
  end

  private
    def assert_legal_links
      [ terms_path, privacy_policy_path ].each do |path|
        assert_select "nav[aria-label='Documentos do Game QTA'] a[href=?][target='_blank'][rel='noopener']", path do
          assert_select ".sr-only", text: "(abre em nova aba)"
        end
      end
    end
end

require "application_system_test_case"

class LegalDocumentsSystemTest < ApplicationSystemTestCase
  test "visitor opens privacy from login and navigates to terms and a section" do
    visit entrar_path

    document_window = window_opened_by do
      click_link "Política de Privacidade"
    end

    within_window document_window do
      assert_current_path privacy_policy_path
      assert_selector "h1", text: "Política de Privacidade"
      assert_text "Minuta — documento em elaboração"

      click_link "Termos de Uso"
      assert_current_path terms_path
      assert_selector "h1", text: "Termos de Uso"

      click_link "3. Regras de participação"
      assert_current_path terms_path do |uri|
        uri.fragment == "section-rules"
      end
      assert_selector "#section-rules", text: "Não tente manipular respostas"
    end

    assert_current_path entrar_path
  ensure
    document_window&.close
  end

  test "documents fit a mobile viewport and preserve their content for printing" do
    page.current_window.resize_to(390, 844)

    [ terms_path, privacy_policy_path ].each do |path|
      visit path
      assert_selector "main article h1"
      assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Document overflows the mobile viewport"

      screen_text = find(".legal-content").text
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", media: "print")

      assert_no_selector ".legal-screen-only", visible: true
      assert_selector "[data-legal-draft]", visible: true
      assert_selector "[data-legal-version]", text: "0.2 — minuta"
      assert_equal screen_text, find(".legal-content").text

      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", media: "screen")
    end
  ensure
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", media: "screen")
    page.current_window.resize_to(1400, 1400)
  end
end

require "application_system_test_case"
require "axe/configuration"

class AccessibilityTest < ApplicationSystemTestCase
  test "public student and admin screens pass automated WCAG A and AA checks" do
    [ entrar_path, cadastrar_path, terms_path, privacy_policy_path, accessibility_path, new_admin_session_path ].each do |path|
      visit path
      assert_accessibility
    end
    login_student
    [ jornada_path, ranking_path, profile_path, edit_profile_path, play_theme_attempt_question_path(theme_attempts(:one)) ].each do |path|
      visit path
      assert_accessibility
    end
    click_on "Mostrar Questão"
    assert_selector "fieldset"
    assert_accessibility
    visit new_admin_session_path
    fill_in "email_address", with: admins(:one).email_address
    fill_in "password", with: "password"
    click_on "Entrar na administração"
    assert_current_path admin_root_path
    [ admin_root_path, admin_students_path, admin_reports_path, admin_admins_path, admin_levels_path, admin_level_themes_path(levels(:one)), new_admin_theme_question_path(themes(:one)) ].each do |path|
      visit path
      assert_accessibility
    end
    page.current_window.resize_to(390, 844)
    [ admin_root_path, admin_students_path, admin_reports_path, new_admin_theme_question_path(themes(:one)) ].each do |path|
      visit path
      assert_operator page.evaluate_script("document.documentElement.scrollWidth"), :<=, page.evaluate_script("window.innerWidth")
    end
  ensure
    page.current_window.resize_to(1400, 1400)
  end

  test "keyboard opens and dismisses level dialog and returns focus" do
    login_student
    trigger = find("button[data-action='click->modal#open']", match: :first)
    trigger.send_keys(:enter)
    assert_selector "dialog[open]"
    assert page.evaluate_script("document.activeElement.closest('dialog') !== null")
    page.driver.browser.action.send_keys(:escape).perform
    assert_no_selector "dialog[open]"
    assert page.evaluate_script("document.activeElement.matches('button[data-action=\"click->modal#open\"]')")
  end

  test "video remains blocked across refusal and navigation and answer requires confirmation" do
    login_student
    visit play_theme_attempt_question_path(theme_attempts(:one))
    assert_no_selector "iframe"
    assert_empty external_requests
    click_on "Continuar sem vídeo"
    assert_no_selector "iframe"
    click_on "Carregar este vídeo"
    assert_selector "iframe[title='Vídeo educativo do YouTube']"
    click_on "Desativar vídeo externo"
    assert_no_selector "iframe"
    select "10× o tempo padrão", from: "Tempo para responder"
    click_on "Mostrar Questão"
    assert_selector "fieldset"
    assert_no_selector "iframe"
    first("input[type=radio]").send_keys(:space)
    assert_button "Confirmar resposta"
    assert_selector "fieldset"
    assert_accessibility
  end

  test "device clock drift does not submit a newly revealed answer" do
    login_student
    visit play_theme_attempt_question_path(theme_attempts(:one))
    page.execute_script("window.originalNow = Date.now; Date.now = () => window.originalNow() + 86400000")
    click_on "Mostrar Questão"
    assert_selector "[role=timer]", text: /00:5[0-9]/, wait: 3
    assert_selector "fieldset"
    assert_button "Confirmar resposta"
  ensure
    page.execute_script("if (window.originalNow) Date.now = window.originalNow")
  end

  test "private history is revalidated after logout" do
    login_student
    visit profile_path
    assert_text users(:student_one).email_address
    click_on "Sair da conta"
    assert_current_path entrar_path
    page.go_back
    assert_current_path entrar_path
    assert_no_text users(:student_one).email_address
  end

  private
    def login_student
      visit entrar_path
      fill_in "E-mail", with: users(:student_one).email_address
      fill_in "Senha", with: "password"
      click_on "Entrar para jogar"
      assert_current_path jornada_path
    end

    def external_requests
      page.evaluate_script("performance.getEntriesByType('resource').filter(e => new URL(e.name).origin !== location.origin).map(e => e.name)")
    end

    def assert_accessibility
      page.execute_script(Axe::Configuration.instance.jslib)
      results = page.driver.browser.execute_async_script(<<~JS)
        const done = arguments[arguments.length - 1];
        axe.run(document, {runOnly: {type: 'tag', values: ['wcag2a','wcag2aa','wcag21a','wcag21aa']}}).then(done);
      JS
      failures = results.fetch("violations").map { |rule| { id: rule["id"], nodes: rule["nodes"].map { |node| node.slice("target", "failureSummary") } } }
      directory = Rails.root.join("tmp/a11y")
      FileUtils.mkdir_p(directory)
      File.write(directory.join("#{current_path.gsub(/[^a-zA-Z0-9]/, '_')}.json"), JSON.pretty_generate(results.slice("url", "violations", "incomplete")))
      assert_empty failures, "#{current_path}: #{JSON.pretty_generate(failures)}"
    end
end

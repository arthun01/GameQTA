require "test_helper"

class Admin::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)

    # Efetuar login de admin via HTTP POST para sessão
    post admin_session_path, params: { email_address: @admin.email_address, password: "password" }
    assert_redirected_to admin_root_path
  end

  test "should get index" do
    get admin_reports_path
    assert_response :success
    assert_select "h1", "Relatórios e Exportações"
  end

  test "should get students csv" do
    get students_admin_reports_path

    assert_response :success
    assert_equal "text/csv; charset=utf-8", response.content_type
    assert_match /attachment; filename="relatorio_estudantes_.*\.csv"/, response.headers["Content-Disposition"]

    # O response body é um Enumerator, precisamos iterar pra pegar o conteúdo real
    csv_content = String.new
    response.stream.each { |chunk| csv_content << chunk }

    assert_match "ID,Nome,Email,Cidade,Nivel_Educacao,Pontuacao_Total,Tempo_Total,Status_Bloqueio,Criado_em", csv_content
    assert_match "student1@example.com", csv_content
  end

  test "should get themes csv" do
    get themes_admin_reports_path

    assert_response :success
    assert_equal "text/csv; charset=utf-8", response.content_type
    assert_match /attachment; filename="relatorio_temas_.*\.csv"/, response.headers["Content-Disposition"]

    csv_content = String.new
    response.stream.each { |chunk| csv_content << chunk }

    assert_match "ID,Tema,Nivel,Total_Tentativas,Total_Acertos,Taxa_Acertos", csv_content
    # student_one answered questions in fixtures? Actually we don't assert specific data because fixtures may vary, just headers.
  end
end

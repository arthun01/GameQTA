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
  end

  test "should sanitize formula injection in students csv" do
    malicious_user = User.create!(
      full_name: "=CMD|' /C calc'!A0",
      email_address: "formula@example.com",
      password: "password123",
      age: 20,
      city: "+Recife",
      education_level: :medio_completo
    )

    get students_admin_reports_path
    assert_response :success

    csv_content = String.new
    response.stream.each { |chunk| csv_content << chunk }

    assert_includes csv_content, "'=CMD|' /C calc'!A0"
    assert_includes csv_content, "'+Recife"
  ensure
    malicious_user&.destroy
  end
end

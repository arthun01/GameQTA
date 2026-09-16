require "application_system_test_case"

class ProgressionTest < ApplicationSystemTestCase
  setup do
    @student = users(:student_one)

    level = Level.create!(name: "Progression Level", description: "Desc", icon: "⭐")
    level.update_column(:id, (Level.minimum(:id) || 0) - 100)

    theme = level.themes.create!(name: "Progression Theme", description: "Desc", icon: "🔥")

    q1 = theme.questions.build(statement: "Test Q 1", difficulty: :easy, youtube_link: "https://youtube.com/watch?v=123", feedback_article: "test")
    q1.options.build(content: "Certa 1", is_correct: true)
    q1.options.build(content: "Errada 1", is_correct: false)
    q1.save!

    q2 = theme.questions.build(statement: "Test Q 2", difficulty: :easy, youtube_link: "https://youtube.com/watch?v=123", feedback_article: "test")
    q2.options.build(content: "Certa 2", is_correct: true)
    q2.options.build(content: "Errada 2", is_correct: false)
    q2.save!

    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"
    assert_selector "h1", text: "Sua Jornada"
  end

  test "progression success" do
    visit jornada_path
    click_on "Iniciar Tema", match: :first

    # Q1
    click_on "Mostrar Questão"
    find("label", text: "Certa 1").click

    # Q2
    click_on "Mostrar Questão"
    find("label", text: "Certa 2").click

    assert_text "Nível Concluído!"
    assert_text "100.0%"
  end
end

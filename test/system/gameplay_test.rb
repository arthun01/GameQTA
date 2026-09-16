require "application_system_test_case"

class GameplayTest < ApplicationSystemTestCase
  setup do
    @student = users(:student_one)

    level = Level.create!(name: "Gameplay Level", description: "Desc", icon: "⭐")
    # Torna este o primeiro nível para ficar desbloqueado
    level.update_column(:id, (Level.minimum(:id) || 0) - 100)

    theme = level.themes.create!(name: "Gameplay Theme", description: "Desc", icon: "🔥")

    q1 = theme.questions.build(statement: "Test Q 1", difficulty: :easy, youtube_link: "https://youtube.com/watch?v=123", feedback_article: "test")
    q1.options.build(content: "Certa 1", is_correct: true)
    q1.options.build(content: "Errada 1", is_correct: false)
    q1.save!

    q2 = theme.questions.build(statement: "Test Q 2", difficulty: :easy, youtube_link: "https://youtube.com/watch?v=123", feedback_article: "test")
    q2.options.build(content: "Certa 2", is_correct: true)
    q2.options.build(content: "Errada 2", is_correct: false)
    q2.save!

    q3 = theme.questions.build(statement: "Test Q 3", difficulty: :easy, youtube_link: "https://youtube.com/watch?v=123", feedback_article: "test")
    q3.options.build(content: "Certa 3", is_correct: true)
    q3.options.build(content: "Errada 3", is_correct: false)
    q3.save!

    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"
    assert_selector "h1", text: "Sua Jornada"
  end

  test "gameplay flow" do
    visit jornada_path
    click_on "Iniciar Tema", match: :first

    # Q1
    click_on "Mostrar Questão"
    assert_text "Test Q 1"

    # Errada:
    find("label", text: "Errada 1").click
    assert_text "Resposta Incorreta"
    click_on "Próxima Questão"

    # Q2
    click_on "Mostrar Questão"
    assert_text "Test Q 2"

    # Timeout
    submission = QuestionSubmission.last
    submission.update!(revealed_at: 2.minutes.ago)
    execute_script("document.getElementById('evaluation_form').requestSubmit()")

    assert_text "Resposta Incorreta"
    click_on "Próxima Questão"

    # Q3
    click_on "Mostrar Questão"
    assert_text "Test Q 3"
    find("label", text: "Certa 3").click

    # Redirecionou pra finish!
    assert_text "Nível Reprovado!"
  end
end

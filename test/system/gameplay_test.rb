require "application_system_test_case"

class GameplayTest < ApplicationSystemTestCase
  setup do
    @student = users(:student_one)
    ThemeAttempt.destroy_all
    QuestionSubmission.destroy_all
    Question.where(statement: ["Test Q 1", "Test Q 2", "Test Q 3", "Test Q 4"]).destroy_all

    visit entrar_path
    fill_in "E-mail", with: @student.email_address
    fill_in "Senha", with: "password"
    click_button "Entrar para jogar"
    assert_selector "h1", text: "Sua Jornada"
  end

  test "student can start theme, watch video and reveal question with working timer" do
    unlocked_level = Level.order(:id).first
    theme = unlocked_level.themes.first
    q = theme.questions.build(statement: "Test Q 1", difficulty: :easy, youtube_link: "https://www.youtube.com/watch?v=123", feedback_article: "test")
    q.options.build(content: "A", is_correct: true)
    q.options.build(content: "B", is_correct: false)
    q.save!

    visit jornada_path
    assert_selector "h2", text: unlocked_level.name
    click_on "Iniciar Tema", match: :first

    assert_selector "button", text: "Mostrar Questão"
    click_on "Mostrar Questão"

    assert_text q.statement
    assert_selector "[data-gameplay-timer-target='display']", text: "01:00"
  end

  test "submissão com opção errada mostra modal de erro" do
    unlocked_level = Level.order(:id).first
    theme = unlocked_level.themes.first
    q = theme.questions.build(statement: "Test Q 2", difficulty: :easy, youtube_link: "https://www.youtube.com/watch?v=123", feedback_article: "test")
    q.options.build(content: "Certa", is_correct: true)
    q.options.build(content: "Errada", is_correct: false)
    q.save!

    visit jornada_path
    click_on "Iniciar Tema", match: :first
    
    assert_selector "button", text: "Mostrar Questão"
    click_on "Mostrar Questão"

    assert_text q.statement
    find('label', text: 'Errada').click

    assert_text "Resposta Incorreta"
    click_on "Próxima Questão"
    
    assert_text "Tema concluído!"
  end

  test "timeout conta como erro e mostra modal" do
    unlocked_level = Level.order(:id).first
    theme = unlocked_level.themes.first
    q = theme.questions.build(statement: "Test Q 3", difficulty: :easy, youtube_link: "https://www.youtube.com/watch?v=123", feedback_article: "test")
    q.options.build(content: "Certa", is_correct: true)
    q.options.build(content: "Errada", is_correct: false)
    q.save!

    visit jornada_path
    click_on "Iniciar Tema", match: :first
    
    assert_selector "button", text: "Mostrar Questão"
    click_on "Mostrar Questão"

    assert_text q.statement

    submission = QuestionSubmission.last
    submission.update!(revealed_at: 2.minutes.ago)
    execute_script("document.getElementById('evaluation_form').requestSubmit()")

    assert_text "Resposta Incorreta"
  end

  test "submissão com opção certa redireciona para a próxima" do
    unlocked_level = Level.order(:id).first
    theme = unlocked_level.themes.first
    q = theme.questions.build(statement: "Test Q 4", difficulty: :easy, youtube_link: "https://www.youtube.com/watch?v=123", feedback_article: "test")
    q.options.build(content: "Certa", is_correct: true)
    q.options.build(content: "Errada", is_correct: false)
    q.save!

    visit jornada_path
    click_on "Iniciar Tema", match: :first
    
    assert_selector "button", text: "Mostrar Questão"
    click_on "Mostrar Questão"

    assert_text q.statement
    find('label', text: 'Certa').click

    assert_text "Tema concluído!"
  end
end

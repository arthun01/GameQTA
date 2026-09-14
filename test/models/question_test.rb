require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  setup do
    @theme = themes(:one)
  end

  test "should be valid with 1 correct option and total 3 options" do
    question = Question.new(
      statement: "Teste?",
      youtube_link: "https://youtube.com/watch?v=123",
      feedback_article: "Feedback",
      difficulty: "easy",
      theme: @theme,
      options_attributes: [
        { content: "A", is_correct: true },
        { content: "B", is_correct: false },
        { content: "C", is_correct: false }
      ]
    )
    assert question.valid?
  end

  test "should fail without any correct option" do
    question = Question.new(
      statement: "Teste?",
      youtube_link: "https://youtube.com/watch?v=123",
      feedback_article: "Feedback",
      difficulty: "easy",
      theme: @theme,
      options_attributes: [
        { content: "A", is_correct: false },
        { content: "B", is_correct: false },
        { content: "C", is_correct: false }
      ]
    )
    assert_not question.valid?
    assert_includes question.errors[:options], "deve ter exatamente 1 opção correta"
  end

  test "should fail with 2 correct options" do
    question = Question.new(
      statement: "Teste?",
      youtube_link: "https://youtube.com/watch?v=123",
      feedback_article: "Feedback",
      difficulty: "easy",
      theme: @theme,
      options_attributes: [
        { content: "A", is_correct: true },
        { content: "B", is_correct: true },
        { content: "C", is_correct: false }
      ]
    )
    assert_not question.valid?
    assert_includes question.errors[:options], "deve ter exatamente 1 opção correta"
  end

  test "should fail with only 1 option total" do
    question = Question.new(
      statement: "Teste?",
      youtube_link: "https://youtube.com/watch?v=123",
      feedback_article: "Feedback",
      difficulty: "easy",
      theme: @theme,
      options_attributes: [
        { content: "A", is_correct: true }
      ]
    )
    assert_not question.valid?
    assert_includes question.errors[:options], "deve conter de 2 a 5 opções"
  end

  test "should fail with more than 5 options" do
    question = Question.new(
      statement: "Teste?",
      youtube_link: "https://youtube.com/watch?v=123",
      feedback_article: "Feedback",
      difficulty: "easy",
      theme: @theme,
      options_attributes: [
        { content: "1", is_correct: true },
        { content: "2", is_correct: false },
        { content: "3", is_correct: false },
        { content: "4", is_correct: false },
        { content: "5", is_correct: false },
        { content: "6", is_correct: false }
      ]
    )
    assert_not question.valid?
    assert_includes question.errors[:options], "deve conter de 2 a 5 opções"
  end

  test "should destroy options when question is destroyed" do
    question = questions(:one)
    assert_difference("Option.count", -3) do
      question.destroy
    end
  end
end

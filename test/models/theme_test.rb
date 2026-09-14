require "test_helper"

class ThemeTest < ActiveSupport::TestCase
  setup do
    @theme = themes(:one)
  end

  test "should be valid" do
    assert @theme.valid?
  end

  test "should not destroy if has questions" do
    assert_not @theme.questions.empty?

    assert_no_difference("Theme.count") do
      @theme.destroy
    end

    assert_not_empty @theme.errors[:base]
  end
end

require "test_helper"

class OptionTest < ActiveSupport::TestCase
  setup do
    @option = options(:one_opt1)
  end

  test "should be valid" do
    assert @option.valid?
  end

  test "should require content" do
    @option.content = nil
    assert_not @option.valid?
  end

  test "is_correct must be true or false" do
    @option.is_correct = nil
    assert_not @option.valid?
  end
end

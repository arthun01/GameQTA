require "test_helper"

class LevelTest < ActiveSupport::TestCase
  test "should not save level without name" do
    level = Level.new(description: "Uma descrição legal")
    assert_not level.save, "Saved the level without a name"
  end

  test "should not save level without description" do
    level = Level.new(name: "Nível 1")
    assert_not level.save, "Saved the level without a description"
  end

  test "should save valid level" do
    level = Level.new(name: "Nível 1", description: "Uma descrição legal")
    assert level.save, "Failed to save the valid level"
  end
end

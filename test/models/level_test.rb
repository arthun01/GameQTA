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

  test "should restrict deletion if themes are present" do
    level = levels(:one)
    Theme.create!(name: "Tema 1", description: "Desc", icon: "📚", level: level)

    assert_not level.destroy, "Destroyed the level with themes"
    assert_match(/não pode ser excluído porque possui (themes|temas) associados/, level.errors[:base].join)
  end
end

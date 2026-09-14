require "test_helper"

class ThemeTest < ActiveSupport::TestCase
  test "should not save theme without name" do
    theme = Theme.new(description: "Desc", icon: "📚", level: levels(:one))
    assert_not theme.save
  end

  test "should not save theme without description" do
    theme = Theme.new(name: "Name", icon: "📚", level: levels(:one))
    assert_not theme.save
  end

  test "should not save theme without icon" do
    theme = Theme.new(name: "Name", description: "Desc", level: levels(:one))
    assert_not theme.save
  end

  test "should not save theme without level" do
    theme = Theme.new(name: "Name", description: "Desc", icon: "📚")
    assert_not theme.save
  end

  test "should save valid theme" do
    theme = Theme.new(name: "Name", description: "Desc", icon: "📚", level: levels(:one))
    assert theme.save
  end
end

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save without required parameters" do
    user = User.new
    assert_not user.save, "Saved the user without required attributes"
    assert_includes user.errors[:full_name], "não pode ficar em branco"
    assert_includes user.errors[:age], "não pode ficar em branco"
    assert_includes user.errors[:city], "não pode ficar em branco"
    assert_includes user.errors[:education_level], "não pode ficar em branco"
  end

  test "should reject invalid education_level" do
    assert_raises(ArgumentError) do
      User.new(education_level: "doutorado")
    end
  end

  test "should save with all valid attributes" do
    user = User.new(
      email_address: "joao@example.com",
      password: "password123",
      full_name: "João Silva",
      age: 20,
      city: "São Paulo",
      education_level: :superior_incompleto
    )
    assert user.save, "Failed to save valid user"
  end
end

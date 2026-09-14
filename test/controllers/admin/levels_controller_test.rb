require "test_helper"

class Admin::LevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @level = levels(:one)
    sign_in_as(@admin)
  end

  test "should get index" do
    get admin_levels_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_level_url
    assert_response :success
  end

  test "should create level" do
    assert_difference("Level.count") do
      post admin_levels_url, params: { level: { name: "Novo Nível", description: "Descrição", icon: "🌱" } }
    end
    assert_redirected_to admin_levels_url
  end

  test "should not create invalid level" do
    assert_no_difference("Level.count") do
      post admin_levels_url, params: { level: { name: "", description: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_level_url(@level)
    assert_response :success
  end

  test "should update level" do
    patch admin_level_url(@level), params: { level: { name: "Atualizado" } }
    assert_redirected_to admin_levels_url
    @level.reload
    assert_equal "Atualizado", @level.name
  end

  test "should destroy level" do
    assert_difference("Level.count", -1) do
      delete admin_level_url(@level)
    end
    assert_redirected_to admin_levels_url
  end
end

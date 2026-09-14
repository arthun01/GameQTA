require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:student_one)
  end

  test "should redirect to login if not authenticated" do
    get "/jornada"
    assert_redirected_to "/entrar"
  end

  test "should get index and load levels with themes" do
    sign_in_as_user(@user)
    get "/jornada"
    assert_response :success

    levels = @controller.instance_variable_get(:@levels)
    assert_not_nil levels
    assert levels.first.starting_level?
  end
end

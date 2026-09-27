require "test_helper"

class RankingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:student_one)
    post "/entrar", params: { email_address: @user.email_address, password: "password" }
  end

  test "should get index" do
    get ranking_url
    assert_response :success
    assert_select "div", text: "Ranking Global"
  end
end

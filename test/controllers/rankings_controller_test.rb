require "test_helper"

class RankingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:student_one)
    post "/entrar", params: { email_address: @user.email_address, password: "password" }
  end

  test "should get index" do
    get ranking_url
    assert_response :success
    assert_select "h1", text: "Ranking Global"
  end

  test "ranking uses generated codes and does not expose participant names or profile data" do
    get ranking_url

    assert_response :success
    assert_equal "no-store", response.headers["Cache-Control"]
    [ users(:student_one), users(:student_two) ].each do |user|
      assert_includes response.body, user.ranking_name
      assert_not_includes response.body, user.full_name
      assert_not_includes response.body, user.email_address
      assert_not_includes response.body, user.city
    end
  end

  test "ranking list beyond the podium also uses codes" do
    users(:student_one).leaderboard.destroy!
    [ 1, 2, 3, 4 ].each do |number|
      user = User.create!(full_name: "Privado #{number}", email_address: "private#{number}@example.com", password: "password", age: 15, city: "Ilhéus", education_level: :medio_incompleto)
      user.create_leaderboard!(total_score: number * 10, total_time_taken: number)
    end

    get ranking_url

    assert_response :success
    assert_not_includes response.body, "Privado"
    assert_select ".bg-white", text: /Jogador [A-F0-9]{12}/
  end
end

require "test_helper"

class TimePreferencesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:student_one)
    sign_in_as_user @user
  end

  test "preference is optional collapsed by default and saves without a password" do
    get profile_path
    assert_select "details#response-time-preference:not([open])"
    assert_select "select[name='user[response_time_multiplier]'] option[selected][value='1']"
    original_email = @user.email_address
    patch profile_time_preference_path, params: { user_id: users(:student_two).id, user: {
      response_time_multiplier: "10", email_address: "changed@example.com", blocked_at: Time.current
    } }
    assert_redirected_to profile_path
    assert_equal 10, @user.reload.response_time_multiplier
    assert_equal original_email, @user.email_address
    assert_not @user.blocked?
    assert_equal 1, users(:student_two).reload.response_time_multiplier
  end

  test "invalid preferences preserve the stored choice and show accessible errors" do
    @user.update!(response_time_multiplier: 3)
    [ "0", "11", "1.5", "abc", "", nil ].each do |value|
      patch profile_time_preference_path, params: { user: { response_time_multiplier: value } }
      assert_response :unprocessable_entity
      assert_equal 3, @user.reload.response_time_multiplier
      assert_select "details#response-time-preference[open]"
      assert_select "select[name='user[response_time_multiplier]'][aria-invalid=true]"
      assert_no_match(/translation missing/i, response.body)
    end
  end

  test "only the authenticated account can change its preference" do
    sign_out_user
    patch profile_time_preference_path, params: { user: { response_time_multiplier: "2" } }
    assert_redirected_to entrar_path
    assert_equal 1, @user.reload.response_time_multiplier
  end

  test "profile preference remains available while renewed legal acceptance is pending" do
    @user.legal_acceptances.destroy_all
    patch profile_time_preference_path, params: { user: { response_time_multiplier: "2" } }
    assert_redirected_to profile_path
    assert_equal 2, @user.reload.response_time_multiplier
  end
end

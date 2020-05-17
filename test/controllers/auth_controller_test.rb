require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest

  test "should get create" do
    sign_in users(:dylan)
    get auth_strava_code_url
    assert_redirected_to setup_url
  end

  test "should redirect create when not logged in" do
    get auth_strava_code_url
    assert_redirected_to new_user_session_url
  end
end

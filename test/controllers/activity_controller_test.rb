require 'test_helper'

class ActivityControllerTest < ActionDispatch::IntegrationTest
  test "should redirect create when not logged in" do
    post activities_url
    assert_redirected_to new_user_session_url
  end

  test "should redirect create when logged in with no auth" do
    sign_in users(:dylan)
    post activities_url
    assert_redirected_to setup_url
  end
end

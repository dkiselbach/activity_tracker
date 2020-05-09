require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get user_profile_url
    assert_response :success
  end

  test "should get activities" do
    get user_activities_url
    assert_response :success
  end

end

require 'test_helper'

class OauthControllerTest < ActionDispatch::IntegrationTest
  test "should get authorize" do
    get oauth_authorize_url
    assert_response :success
  end

  test "should get access" do
    get oauth_access_url
    assert_response :success
  end

  test "should get refresh" do
    get oauth_refresh_url
    assert_response :success
  end

  test "should get auth_code" do
    get oauth_auth_code_url
    assert_response :success
  end

end

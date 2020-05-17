require 'test_helper'

class AuthIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    @user_without_auth = users(:dylan)
  end

  test "Create auth with valid code and scope" do
    #Retrieve tokens successfully
    stub_auth_request_success
    get new_user_session_path
    sign_in @user_without_auth
    get setup_path
    assert_select 'p', "Connect to Strava in order to sync your activities to the Activity Tracker App."
    get auth_strava_code_path(code: "Valid_Code",scope: "read,activity:read")
    assert @user_without_auth.reload.auth.valid?
    assert_equal "Valid_Token", @user_without_auth.reload.auth.token
    get setup_path
    assert_select 'p', "Strava is already connected. If you are experiencing issues, click the button below."
  end

  test "Create auth with invalid code and valid scope" do
    #try to retrieve tokens with invalid code
    stub_auth_request_failure
    get new_user_session_path
    sign_in @user_without_auth
    get setup_path
    assert_select 'p', "Connect to Strava in order to sync your activities to the Activity Tracker App."
    get auth_strava_code_path(code: "Invalid_Code",scope: "read,activity:read")
    assert @user_without_auth.reload.auth.nil?
    assert_redirected_to setup_path
    follow_redirect!
    assert_template 'static_pages/setup'
    assert_equal "There was an issue with the authorization. Please try again.", flash[:danger]
    assert_select 'p', "Connect to Strava in order to sync your activities to the Activity Tracker App."
    get root_path
    assert flash.empty?
  end

  test "Create auth with valid code and invalid scope" do
    stub_auth_request_success
    get new_user_session_path
    sign_in @user_without_auth
    get setup_path
    assert_select 'p', "Connect to Strava in order to sync your activities to the Activity Tracker App."
    get auth_strava_code_path(code: "Valid_Code",scope: "read,activity:read,activity:write")
    assert @user_without_auth.reload.auth.nil?
    assert_redirected_to setup_path
    follow_redirect!
    assert_template 'static_pages/setup'
    assert_equal "You need to authorize the integration from Strava. Please try again, and ensure to include activities in the authentication.", flash[:danger]
    assert_select 'p', "Connect to Strava in order to sync your activities to the Activity Tracker App."
    get root_path
    assert flash.empty?
  end
end

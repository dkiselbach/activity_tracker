require 'test_helper'

class ActivitiesTest < ActionDispatch::IntegrationTest

  setup do
    @user_with_auth = users(:dustin)
    @user_without_auth = users(:dylan)
  end

  test "redirect to setup path if user has not setup auth" do
    #try to sync before logging in
    post activities_path
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
    #try to sync without auth
    sign_in @user_without_auth
    get sync_activities_path
    post activities_path
    assert_redirected_to setup_path
    follow_redirect!
    assert_equal "Connect to Strava first before syncing your activities.", flash[:danger]
    get root_url
    assert flash.empty?
  end

  test "redirect to setup path if refresh token fails" do
    stub_athlete_auth_error
    stub_refresh_token_error
    get new_user_session_path
    #try to sync with invalid auth
    sign_in @user_with_auth
    get sync_activities_path
    post activities_path
    assert_redirected_to setup_path
    follow_redirect!
    assert_equal "Something went wrong with your authentication. Please connect to Strava again.", flash[:danger]
    get root_url
    assert flash.empty?
  end
end

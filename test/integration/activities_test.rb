require 'test_helper'

class ActivitiesTest < ActionDispatch::IntegrationTest

  setup do
    @user_with_valid_refresh = users(:jimbo)
    @user_with_invalid_auth = users(:dustin)
    @user_with_valid_auth = users(:emily)
    @user_without_auth = users(:dylan)
  end

  test "sync activities with valid auth" do
    #auth check succeeds
    stub_athlete_auth_success
    #activity request succeeds
    stub_activities_success
    get new_user_session_path
    #sync with valid auth
    sign_in @user_with_valid_auth
    get sync_activities_path
    assert_difference "@user_with_valid_auth.activity.count", 2 do
      post activities_path
    end
    @user_with_valid_auth.reload
    assert_equal "16096", @user_with_valid_auth.activity.first.distance.to_s
    assert_equal "6441", @user_with_valid_auth.activity.second.distance.to_s
    #sync again and ensure new activities aren't created
    assert_no_difference "@user_with_valid_auth.activity.count" do
      post activities_path
    end
    assert_redirected_to sync_activities_path
    follow_redirect!
    assert_equal "Your activities were synced succesfully.", flash[:success]
    get root_url
    assert flash.empty?
  end

  test "sync activities with refresh auth required" do
    #auth check fails
    stub_athlete_auth_error
    #refresh succeeds
    stub_refresh_token_success
    #auth check succeeds now with token refreshed
    stub_athlete_auth_success
    #activity request succeeds with new auth
    stub_activities_success
    get new_user_session_path
    sign_in @user_with_valid_refresh
    get sync_activities_path
    assert_difference "@user_with_valid_refresh.activity.count", 2 do
      post activities_path
    end
    #check the token to make sure it is valid now
    @user_with_valid_refresh.reload
    assert_equal "Valid_Token", @user_with_valid_refresh.auth.token
    assert_equal "16096", @user_with_valid_refresh.activity.first.distance.to_s
    assert_equal "6441", @user_with_valid_refresh.activity.second.distance.to_s
    #sync again and ensure new activities aren't created
    assert_no_difference "@user_with_valid_auth.activity.count" do
      post activities_path
    end
    assert_redirected_to sync_activities_path
    follow_redirect!
    assert_equal "Your activities were synced succesfully.", flash[:success]
    get root_url
    assert flash.empty?
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

  test "redirect to setup path if refresh auth fails" do
    #auth check fails
    stub_athlete_auth_error
    #refresh fails
    stub_refresh_token_error
    get new_user_session_path
    #try to sync with invalid auth
    sign_in @user_with_invalid_auth
    get sync_activities_path
    post activities_path
    assert_redirected_to setup_path
    follow_redirect!
    assert_equal "Something went wrong with your authentication. Please connect to Strava again.", flash[:danger]
    get root_url
    assert flash.empty?
  end
end

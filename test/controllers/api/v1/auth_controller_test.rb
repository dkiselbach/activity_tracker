# frozen_string_literal: true

require 'test_helper'

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_without_auth = users(:dylan)
    @user_with_valid_auth = users(:emily)
    @user_with_valid_refresh = users(:jimbo)
    @user_with_invalid_auth = users(:dustin)
  end

  test 'get index with no auth should return error' do
    jwt_login(@user_without_auth)
    get api_v1_auth_index_url
    json_response = JSON.parse(response.body)
    assert_equal ['Authentication is invalid'], json_response['error']['authentication']
  end

  test 'get index should return error when user no auth' do
    jwt_login(@user_without_auth)
    get api_v1_auth_index_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal 'User has no auth', json_response['error']['message']
  end

  test 'get index should refresh auth when user has expired token' do
    # user's auth token has expired
    stub_athlete_auth_error
    # user has a valid refresh and gets a new token
    stub_refresh_token_success
    jwt_login(@user_with_valid_refresh)
    get api_v1_auth_index_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth is valid'], json_response['success']
    assert_not @user_with_valid_refresh.auth.nil?
  end

  test 'get index should return true when user has valid auth' do
    # user's auth token is valid
    stub_athlete_auth_success
    jwt_login(@user_with_valid_auth)
    get api_v1_auth_index_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth is valid'], json_response['success']
    assert_not @user_with_valid_auth.auth.nil?
  end

  test 'get index should throttle when API rate limited' do
    # user's auth token is valid but throttled
    stub_athlete_auth_throttled
    jwt_login(@user_with_valid_auth)
    assert_difference 'Throttle.count', 1 do
      get api_v1_auth_index_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth is valid but api is rate limited'], json_response['success']
    assert_not @user_with_valid_auth.auth.nil?
  end

  test 'get index should be throttled when throttled' do
    # user's auth token is valid but throttled
    stub_athlete_auth_throttled
    jwt_login(@user_with_valid_auth)
    # API is throttled
    assert_difference 'Throttle.count', 1 do
      get api_v1_auth_index_url, headers: @authorization
    end
    # request should not go through
    assert_no_difference 'Throttle.count' do
      get api_v1_auth_index_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth is valid but api is rate limited'], json_response['success']
    assert_not @user_with_valid_auth.auth.nil?
  end

  test 'get index should return error when user has expired token and invalid refresh token' do
    # user's auth token has expired
    stub_athlete_auth_error
    # user refresh token is invalid and gets an error
    stub_refresh_token_error
    jwt_login(@user_with_invalid_auth)
    assert_difference 'Auth.count', -1 do
      get api_v1_auth_index_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth is invalid and has been removed'], json_response['error']['strava_auth']
    assert @user_with_invalid_auth.reload.auth.nil?
  end

  test 'post create with no auth should return error' do
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url
    json_response = JSON.parse(response.body)
    assert_equal ['Authentication is invalid'], json_response['error']['authentication']
  end

  test 'post create with no params should return error' do
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['is blank'], json_response['error']['auth_code']
    assert_equal ['is blank or invalid'], json_response['error']['scope']
    assert @user_without_auth.reload.auth.nil?
  end

  test 'post create with no scope should return error' do
    jwt_login(@user_without_auth)
    post "#{api_v1_auth_index_url}?code=Valid_Code", headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['is blank or invalid'], json_response['error']['scope']
    assert @user_without_auth.reload.auth.nil?
  end

  test 'post create with no code should return error' do
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url(scope: ENV['STRAVA_SCOPE']), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['is blank'], json_response['error']['auth_code']
    assert @user_without_auth.reload.auth.nil?
  end

  test 'post create with incorrect scope should return error' do
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url(scope: 'read,read_all,profile:read_all,profile:write', code: 'Valid_Code'), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['is blank or invalid'], json_response['error']['scope']
    assert @user_without_auth.reload.auth.nil?
  end

  test 'post create with invalid code should return error' do
    # user auth request is successful
    stub_auth_request_error
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url(scope: ENV['STRAVA_SCOPE'], code: 'Invalid_Code'), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ['is invalid'], json_response['error']['auth_code']
    assert @user_without_auth.reload.auth.nil?
  end

  test 'post create with valid params should create auth' do
    # user auth request is successful
    stub_auth_request_success
    # assert there is no profile image attached
    assert_not @user_without_auth.image.attached?
    # assert the user has no auth
    assert @user_without_auth.auth.nil?
    jwt_login(@user_without_auth)
    post api_v1_auth_index_url(scope: ENV['STRAVA_SCOPE'], code: 'Valid_Code'), headers: @authorization
    assert @user_without_auth.reload.auth.valid?
    assert_equal 'Valid_Token', @user_without_auth.reload.auth.token
    assert_equal 'Valid_Refresh', @user_without_auth.reload.auth.refresh_token
    json_response = JSON.parse(response.body)
    assert_equal ['Strava successfully connected'], json_response['success']
    @user_without_auth.reload
    assert @user_without_auth.image.attached?
    assert_equal @user_without_auth.strava_sex, 'M'
    assert_equal @user_without_auth.strava_city, 'San Francisco'
  end

  test 'disconnect with valid auth should remove auth' do
    # user successfully deauthorizes
    stub_deauthorize_success
    jwt_login(@user_with_valid_auth)
    assert_difference 'Auth.count', -1 do
      delete api_v1_auth_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth successfully deauthorized'], json_response['success']
    assert @user_with_valid_auth.reload.auth.nil?
  end

  test 'disconnect auth with invalid auth should not remove auth' do
    jwt_login(@user_with_valid_auth)
    assert_no_difference 'Auth.count' do
      delete api_v1_auth_url
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Authentication is invalid'], json_response['error']['authentication']
    assert @user_with_valid_auth.auth.valid?
  end

  test 'disconnect auth with valid auth but no strava auth should return disconnected' do
    jwt_login(@user_without_auth)
    assert_no_difference 'Auth.count' do
      delete api_v1_auth_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['User has no Strava auth'], json_response['success']
  end

  test 'disconnect auth with valid auth but invalid auth token and refresh token should remove auth' do
    # user does not deauthorize
    stub_deauthorize_failure
    # user refresh fails
    stub_refresh_token_error
    jwt_login(@user_with_invalid_auth)
    assert_difference 'Auth.count', -1 do
      delete api_v1_auth_url, headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_equal ['Strava auth successfully deauthorized'], json_response['success']
    assert @user_with_invalid_auth.reload.auth.nil?
  end
end

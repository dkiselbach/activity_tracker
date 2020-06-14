require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:dustin)
    @user_without_auth = users(:dylan)
  end

  test "get index with no auth should return error" do
    get api_v1_users_url
    json_response = JSON.parse(response.body)
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "get index should return true when user has valid auth" do
    sign_in(@user)
    get api_v1_users_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal 2, json_response["id"]
    assert_equal 3, json_response["longest_run"]["id"]
    assert_equal 4, json_response["longest_ride"]["id"]
    assert_equal 1, json_response["fastest_half_marathon"]["id"]
    assert_nil json_response["profile_image"]
  end

  test "get index should return image url when user has a valid profile image" do
    #get a new profile image
    stub_auth_request_success
    sign_in(@user_without_auth)
    get api_v1_users_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_nil json_response["profile_image"]
    post api_v1_auth_index_url(scope: "read,activity:read_all,read_all", code: "Valid_Code"), headers: @authorization
    get api_v1_user_url(id: 1), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal url_for(@user_without_auth.image), json_response["profile_image"]
  end

  test "get show with no auth should return error" do
    get api_v1_users_url(id: 1)
    json_response = JSON.parse(response.body)
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "get show should return true when user has valid auth" do
    sign_in(@user)
    get api_v1_user_url(id: 2), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal 2, json_response["id"]
    assert_equal 3, json_response["longest_run"]["id"]
    assert_equal 4, json_response["longest_ride"]["id"]
    assert_equal 1, json_response["fastest_half_marathon"]["id"]
    assert_nil json_response["profile_image"]
  end

  test "get show should return image url when user has a valid profile image" do
    #get a new profile image
    stub_auth_request_success
    sign_in(@user_without_auth)
    get api_v1_user_url(id: 1), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_nil json_response["profile_image"]
    post api_v1_auth_index_url(scope: "read,activity:read_all,read_all", code: "Valid_Code"), headers: @authorization
    get api_v1_user_url(id: 1), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal url_for(@user_without_auth.image), json_response["profile_image"]
  end

  test "image purge should be enqueued" do
    #get a new profile image
    stub_auth_request_success
    sign_in(@user_without_auth)
    post api_v1_auth_index_url(scope: "read,activity:read_all,read_all", code: "Valid_Code"), headers: @authorization
    assert_enqueued_jobs 1
  end

  test "update user with no auth should return error" do
    patch api_v1_user_url(id: 2)
    json_response = JSON.parse(response.body)
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "update user with auth should return updated user" do
    sign_in(@user_without_auth)
    patch api_v1_user_url(id: 2, user: {name: "Test 123", email: "testing@test.com"}), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal "Test 123", json_response["name"]
    assert_equal "testing@test.com", json_response["email"]
  end
end

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
    patch api_v1_user_url(id: 1)
    json_response = JSON.parse(response.body)
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "update user with auth should return updated user" do
    sign_in(@user_without_auth)
    patch api_v1_user_url(id: 1, user: {name: "Test 123", email: "testing@test.com", weight: 123, height: 124}), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal "Test 123", json_response["name"]
    assert_equal "testing@test.com", json_response["email"]
    assert_equal 123, json_response["weight"]
    assert_equal 124, json_response["height"]
  end

  test "update user with invalid user_id should return error" do
    sign_in(@user_without_auth)
    patch api_v1_user_url(id: 2, user: {name: "Test 123", email: "testing@test.com"}), headers: @authorization
    json_response = JSON.parse(response.body)
    assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["user"]

  end

  test "update user weight should create a new biometrics log" do
    sign_in(@user)
    assert_difference "Biometric.count", 1 do
      patch api_v1_user_url(id: 2, user: {weight: 123}), headers: @authorization
    end
    assert_response 200
    json_response = JSON.parse(response.body)
    assert_equal 123, json_response["weight"]
    assert_equal 123, @user.biometric.last.weight
  end

  test "update user weight should not create a new biometrics log if out of range" do
    sign_in(@user)
    assert_difference 'Biometric.count', 0 do
      patch api_v1_user_url(id: 2, user: {weight: 1000, height: 1000}), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["must be less than 500"], json_response["error"]["params"]["weight"]
    assert_equal ["must be less than 300"], json_response["error"]["params"]["height"]
  end

  test "post create should follower user" do
    sign_in(@user)
    assert_difference 'Relationship.count', 1 do
      post api_v1_users_url(follower_id: 2, followed_id: 2), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ["User successfully followed"], json_response["success"]
  end

  test "delete should unfollower user" do
    sign_in(@user_without_auth)
    assert_difference 'Relationship.count', -1 do
      delete api_v1_user_url(id: 1, followed_id: 3), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ["User successfully unfollowed"], json_response["success"]
  end

  test "post create should throw error for invalid followed id" do
    sign_in(@user)
    assert_difference 'Relationship.count', 0 do
      post api_v1_users_url(follower_id: 2, followed_id: 100), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 404
    assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["user"]
  end

  test "post create should throw error for already followed id" do
    sign_in(@user)
    post api_v1_users_url(follower_id: 2, followed_id: 3), headers: @authorization
    assert_difference 'Relationship.count', 0 do
      post api_v1_users_url(follower_id: 2, followed_id: 3), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["User is already followed"], json_response["error"]["user"]
  end

  test "post create should throw error for wrong user id" do
    sign_in(@user)
    assert_difference 'Relationship.count', 0 do
      post api_v1_users_url(follower_id: 1, followed_id: 3), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["does not match authenticated User"], json_response["error"]["user_id"]
  end

  test "delete should throw error for invalid followed id" do
    sign_in(@user)
    assert_difference 'Relationship.count', 0 do
      delete api_v1_user_url(id: 2, followed_id: 100), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 404
    assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["user"]
  end

  test "delete should throw error for unfollowed" do
    sign_in(@user)
    assert_difference 'Relationship.count', 0 do
      delete api_v1_user_url(id: 2, followed_id: 3), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["User is not currently followed"], json_response["error"]["user"]
  end

  test "delete should throw error for wrong user id" do
    sign_in(@user)
    assert_difference 'Relationship.count', 0 do
      delete api_v1_user_url(id: 1, followed_id: 3), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["does not match authenticated User"], json_response["error"]["user_id"]
  end
end

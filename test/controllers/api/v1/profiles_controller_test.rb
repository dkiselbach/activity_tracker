require 'test_helper'

class Api::V1::ProfilesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:dylan)
  end

  test "get index with no auth should return error" do
    get api_v1_profiles_url
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "get index should return true" do
    jwt_login(@user)
    get api_v1_profiles_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal 2, json_response["profiles"].count
    #assert ordered by created_at date
    assert_equal 2, json_response["profiles"][0]["id"]
    assert_equal 1, json_response["profiles"][1]["id"]
  end

  test "post create should return error when not logged in" do
    post api_v1_profiles_url
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
  end

  test "post create should return success when logged in" do
    jwt_login(@user)
    assert_difference 'Profile.count', 1 do
      post api_v1_profiles_url(profile: {weight: 100, height: 100}), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ["Profile created"], json_response["success"]
  end

  test "post create should return error when values out of range" do
    jwt_login(@user)
    assert_difference 'Profile.count', 0 do
      post api_v1_profiles_url(profile: {weight: 1000, height: 1000}), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["must be less than 500"], json_response["error"]["params"]["weight"]
    assert_equal ["must be less than 300"], json_response["error"]["params"]["height"]
  end

  test "post create should return error when missing param" do
    jwt_login(@user)
    assert_difference 'Profile.count', 0 do
      post api_v1_profiles_url(profile: {weight: 120}), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["can't be blank", "is not a number"], json_response["error"]["params"]["height"]
  end
end

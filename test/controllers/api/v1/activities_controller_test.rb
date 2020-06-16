require 'test_helper'

class Api::V1::ActivitiesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:dylan)
      @user_with_auth = users(:emily)
    end

    test "get index with no auth should return error" do
      get api_v1_activities_url
      json_response = JSON.parse(response.body)
      assert_response 401
      assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
    end

    test "get index with no params should return true" do
      jwt_login(@user)
      get api_v1_activities_url, headers: @authorization
      json_response = JSON.parse(response.body)
      assert_equal 3, json_response["activities"].count
      #assert ordered by start_date_locals
      assert_equal 2, json_response["activities"][0]["id"]
      assert_equal 1, json_response["activities"][1]["id"]
      assert_equal 5, json_response["activities"][2]["id"]
      assert_nil json_response["pagination"]
    end

    test "get index with start and end date should return true" do
      jwt_login(@user)
      get api_v1_activities_url(start_date: Time.now - 5.days, end_date: Time.now - 1.day ), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_equal 2, json_response["activities"].count
      assert_equal 1, json_response["activities"][0]["id"]
      assert_equal 5, json_response["activities"][1]["id"]
      assert_nil json_response["pagination"]
    end

    test "get index with start should return true" do
      jwt_login(@user)
      get api_v1_activities_url(start_date: Time.now - 3.days), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_equal 2, json_response["activities"].count
      assert_equal 2, json_response["activities"][0]["id"]
      assert_equal 1, json_response["activities"][1]["id"]
      assert_nil json_response["pagination"]
    end

    test "get index with page should return true" do
      jwt_login(@user)
      get api_v1_activities_url(page: 1), headers: @authorization
      json_response = JSON.parse(response.body)
      assert json_response["pagination"]
      assert_equal 1, json_response["pagination"]["current_page"]
      assert_equal 1, json_response["pagination"]["total_pages"]
      assert_equal 3, json_response["pagination"]["total"]
      assert_equal 3, json_response["activities"].count
    end

    test "get index with last page should return empty" do
      jwt_login(@user)
      get api_v1_activities_url(page: 2), headers: @authorization
      json_response = JSON.parse(response.body)
      assert json_response["pagination"]
      assert json_response["activities"].empty?
    end

    test "post create should return error when not logged in" do
      post api_v1_activities_url
      json_response = JSON.parse(response.body)
      assert_response 401
      assert_equal ["Authentication is invalid"], json_response["error"]["authentication"]
    end

    test "create when logged in with no auth should return error" do
      jwt_login(@user)
      post api_v1_activities_url, headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 422
      assert_equal ["User has no Auth"], json_response["error"]["auth"]
    end

    test "post create should return success and enqueue active job when logged in" do
      jwt_login(@user_with_auth)
      assert_enqueued_jobs 0
      post api_v1_activities_url, headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 200
      assert_equal ["Activities synced"], json_response["success"]
      assert_enqueued_jobs 1
      assert_enqueued_with(job: ActivitiesSyncJob, args: [@user_with_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"]])
    end

    test "get show with invalid id should return error" do
      jwt_login(@user)
      get api_v1_activity_url(id: 7), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 404
      assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["activity"]
    end

    test "get show with valid id for wrong user should return error" do
      jwt_login(@user)
      get api_v1_activity_url(id: 3), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 404
      assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["activity"]
    end

    test "get show with valid id should return true" do
      jwt_login(@user)
      get api_v1_activity_url(id: 1), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 200
      assert_equal 1, json_response["activity"]["id"]
      assert_equal 30000, json_response["activity"]["distance"]
      assert_equal "No lap data", json_response["laps"]
      assert_equal "No split data", json_response["splits"]
      assert_equal "No split data", json_response["splits_metric"]
    end

    test "update activity with invalid id should return error" do
      jwt_login(@user)
      patch api_v1_activity_url(id: 7, activity: {name: "Test 123", distance: 1000, avg_hr: 123, calories: 123, activity_time: 123}), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 404
      assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["activity"]
    end

    test "update activity with valid id for wrong user should return error" do
      jwt_login(@user)
      patch api_v1_activity_url(id: 3, activity: {name: "Test 123", distance: 1000, avg_hr: 123, calories: 123, activity_time: 123}), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 404
      assert_equal ["does not exist or the user doesn't have access"], json_response["error"]["activity"]
    end

    test "update activity with valid id should return updated activity" do
      jwt_login(@user)
      patch api_v1_activity_url(id: 1, activity: {name: "Test 123", distance: 1000, avg_hr: 123, calories: 123, activity_time: 123}), headers: @authorization
      json_response = JSON.parse(response.body)
      assert_response 200
      assert_equal "Test 123", json_response["name"]
      assert_equal 1000, json_response["distance"]
      assert_equal 123, json_response["avg_hr"]
      assert_equal 123, json_response["calories"]
      assert_equal 123, json_response["activity_time"]
    end
end

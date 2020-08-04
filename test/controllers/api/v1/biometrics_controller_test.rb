# frozen_string_literal: true

require 'test_helper'

class Api::V1::BiometricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:dylan)
    @weight = 180
  end

  test 'get index with no auth should return error' do
    get api_v1_biometrics_url
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ['Authentication is invalid'], json_response['error']['authentication']
  end

  test 'get index should return true' do
    jwt_login(@user)
    get api_v1_biometrics_url, headers: @authorization
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal 2, json_response['biometrics'].count
    # assert ordered by created_at date
    assert_equal 2, json_response['biometrics'][0]['id']
    assert_equal 1, json_response['biometrics'][1]['id']
  end

  test 'post create should return error when not logged in' do
    post api_v1_biometrics_url
    json_response = JSON.parse(response.body)
    assert_response 401
    assert_equal ['Authentication is invalid'], json_response['error']['authentication']
  end

  test 'post create should return success when logged in and enqueue job' do
    jwt_login(@user)
    assert_difference 'Biometric.count', 1 do
      post api_v1_biometrics_url(biometrics: { weight: @weight }), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['Biometrics created'], json_response['success']
    assert_enqueued_jobs 1
    assert_enqueued_with(job: BiometricsUpdateJob,
                         args: [Biometric.last.id, @weight.to_s, @user.id, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET']])
  end

  test 'post create should return error when values out of range' do
    jwt_login(@user)
    assert_difference 'Biometric.count', 0 do
      post api_v1_biometrics_url(biometrics: { weight: 1000 }), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ['must be less than 500'], json_response['error']['params']['weight']
  end

  test 'post create should return error when missing param' do
    jwt_login(@user)
    assert_difference 'Biometric.count', 0 do
      post api_v1_biometrics_url(biometrics: { weight: nil }), headers: @authorization
    end
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ["can't be blank", 'is not a number'], json_response['error']['params']['weight']
  end
end

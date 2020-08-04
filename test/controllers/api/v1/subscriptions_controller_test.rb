# frozen_string_literal: true

require 'test_helper'

class Api::V1::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:dylan)
  end

  test 'get index with invalid subscription secret should return error' do
    get api_v1_subscriptions_url
    json_response = JSON.parse(response.body)
    assert_response 422
    assert_equal ['verify_token is invalid'], json_response['error']['token']
  end

  test 'get index with valid subscription secret should return true' do
    get api_v1_subscriptions_url("hub.verify_token": ENV['WEBHOOK_SECRET_KEY'], "hub.challenge": 12_345)
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal '12345', json_response['hub.challenge']
  end

  test 'post create with invalid strava_id should not enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'create',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'activity',
                                  "owner_id": 20_730_280,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['activity subscription recieved'], json_response['success']
    assert_enqueued_jobs 0
  end

  test 'post create with valid strava_id for user with invalid auth and create webhook should not enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'create',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'activity',
                                  "owner_id": 1212,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['activity subscription recieved'], json_response['success']
    assert_enqueued_jobs 0
  end

  test 'post create with valid strava_id and create webhook should enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'create',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'activity',
                                  "owner_id": 4545,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['activity subscription recieved'], json_response['success']
    assert_enqueued_jobs 1
    assert_enqueued_with(job: ActivityCreateJob, args: ['3585649981', 3, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET']])
  end

  test 'post create with valid strava_id and update webhook should enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'update',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'activity',
                                  "owner_id": 4545,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['activity subscription recieved'], json_response['success']
    assert_enqueued_jobs 1
    assert_enqueued_with(job: ActivityUpdateJob, args: ['3585649981', 3, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET']])
  end

  test 'post create with valid strava_id and delete webhook should enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'delete',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'activity',
                                  "owner_id": 4545,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['activity subscription recieved'], json_response['success']
    assert_enqueued_jobs 1
    assert_enqueued_with(job: ActivityDeleteJob, args: ['3585649981'])
  end

  test 'post create with valid strava_id and athlete object type should not enqueue active job' do
    post api_v1_subscriptions_url("aspect_type": 'update',
                                  "event_time": 1_590_860_440,
                                  "object_id": 3_585_649_981,
                                  "object_type": 'athlete',
                                  "owner_id": 4545,
                                  "subscription_id": 157_853,
                                  "updates": {})
    json_response = JSON.parse(response.body)
    assert_response 200
    assert_equal ['athlete subscription recieved'], json_response['success']
    assert_enqueued_jobs 0
  end
end

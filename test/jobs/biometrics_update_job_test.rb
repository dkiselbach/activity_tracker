# frozen_string_literal: true

require 'test_helper'

class BiometricsUpdateJobTest < ActiveJob::TestCase
  setup do
    @user_with_valid_auth = users(:emily)
    @user_with_invalid_auth = users(:dustin)
    @user_with_valid_refresh = users(:jimbo)
    @weight = 180
  end

  test 'Job ran with user with expired token should be refreshed and retried' do
    # first request will throw exception
    stub_athlete_update_error
    # token refreshed after exception
    stub_refresh_token_success
    # second request successful
    stub_athlete_update_success

    biometric = @user_with_valid_refresh.biometric.create(weight: 180)
    assert_not biometric.strava_updated
    BiometricsUpdateJob.perform_now(biometric.id, @weight,
                                    @user_with_valid_refresh.id, ENV['STRAVA_CLIENT_ID'],
                                    ENV['STRAVA_CLIENT_SECRET'])
    assert_enqueued_jobs 1
    assert_equal 'Valid_Token', @user_with_valid_refresh.auth.reload.token
    perform_enqueued_jobs
    assert_performed_jobs 1
    assert biometric.reload.strava_updated
  end

  test 'Job ran with user with invalid auth should not be retried' do
    # first request will throw exception
    stub_athlete_update_error
    # token refreshed after exception
    stub_refresh_token_error

    biometric = @user_with_invalid_auth.biometric.create(weight: 180)
    BiometricsUpdateJob.perform_now(biometric.id, @weight,
                                    @user_with_invalid_auth.id, ENV['STRAVA_CLIENT_ID'],
                                    ENV['STRAVA_CLIENT_SECRET'])
    assert_enqueued_jobs 0
  end

  test 'Job ran with user with valid auth but throttled should schedule job' do
    # request is throttled
    stub_athlete_update_throttled

    biometric = @user_with_valid_auth.biometric.create(weight: 180)
    assert_difference 'Throttle.count', 1 do
      BiometricsUpdateJob.perform_now(biometric.id, @weight, @user_with_valid_auth.id, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
    end
    assert_enqueued_with(job: BiometricsUpdateJob,
                         args: [biometric.id, @weight, @user_with_valid_auth.id,
                                ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET']],
                         at: Time.now.utc.midnight.tomorrow)
  end

  test 'Job ran when throttled should not run' do
    @user_with_valid_auth.throttle.create(hourly_usage: 100, daily_usage: 1000, app_name: 'Strava')

    biometric = @user_with_valid_auth.biometric.create(weight: 180)
    assert_difference 'Throttle.count', 0 do
      BiometricsUpdateJob.perform_now(biometric.id, @weight, @user_with_valid_auth.id, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'])
    end
    assert_enqueued_with(job: BiometricsUpdateJob,
                         args: [biometric.id, @weight, @user_with_valid_auth.id,
                                ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET']],
                         at: Time.now.utc.midnight.tomorrow)
  end
end

require 'test_helper'

class ActivityUpdateJobTest < ActiveJob::TestCase
  setup do
    @user_with_valid_auth = users(:emily)
    @user_with_invalid_auth = users(:dustin)
    @user_with_valid_refresh = users(:jimbo)

  end

  test "Job ran with user with expired token should be refreshed and retried" do
    #first request will throw exception
    stub_detailed_activities_error_1
    #token refreshed after exception
    stub_refresh_token_success
    #enqueue create job with detailed activity 1
    stub_detailed_activities_success_1
    #build activity
    @user_with_valid_refresh.activity.create(strava_id: 3447675367)

    ActivityUpdateJob.perform_now(3447675367, @user_with_valid_refresh.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_enqueued_jobs 1
    assert_equal "Valid_Token", @user_with_valid_refresh.auth.reload.token
    assert_difference "Record.count", 1 do
      perform_enqueued_jobs
    end
    assert_performed_jobs 1
    assert_equal "5k", Record.last.name
    assert_equal 3447675367, Record.last.strava_id
  end

  test "Job ran with user with invalid auth should not be retried" do
    #first request will throw exception
    stub_detailed_activities_error_1
    #token refreshed after exception
    stub_refresh_token_error
    #build activity
    @user_with_invalid_auth.activity.create(strava_id: 3447675367)

    ActivityUpdateJob.perform_now(3447675367, @user_with_invalid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_enqueued_jobs 0
  end

  test "Job ran with user with valid auth but throttled should schedule job" do
    #request is throttled
    stub_throttled_1
    #build activity
    @user_with_valid_auth.activity.create(strava_id: 3447675367)

    assert_difference "Throttle.count", 1 do
      ActivityUpdateJob.perform_now(3447675367, @user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    end
    assert_enqueued_with(job: ActivityUpdateJob, args: [3447675367, @user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"]], at: Time.now.utc.midnight.tomorrow)
  end

  test "Job ran with user_id not matching existing activity should not run" do
    @user_with_valid_refresh.activity.create(strava_id: 3447675367)

    ActivityUpdateJob.perform_now(3447675367, @user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_difference "Record.count", 0 do
      perform_enqueued_jobs
    end
  end

  test "Job ran when throttled should not run" do
    @user_with_valid_auth.activity.create(strava_id: 3447675367)
    @user_with_valid_auth.throttle.create(hourly_usage: 100, daily_usage: 1000, app_name: "Strava")

    assert_difference "Record.count", 0 do
      ActivityUpdateJob.perform_now(3447675367, @user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    end
    assert_enqueued_with(job: ActivityUpdateJob, args: [3447675367, @user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"]], at: Time.now.utc.midnight.tomorrow)
  end
end

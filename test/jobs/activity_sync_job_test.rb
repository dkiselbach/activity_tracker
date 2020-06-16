require 'test_helper'

class ActivitySyncJobTest < ActiveJob::TestCase
  setup do
    @user_with_valid_auth = users(:emily)
    @user_with_invalid_auth = users(:dustin)
    @user_with_valid_refresh = users(:jimbo)
  end

  test "Job ran with user with expired token should be refreshed and retried" do
    #first request will throw exception
    stub_activities_error
    #token refreshed after exception
    stub_refresh_token_success
    #activities successful now with refresh
    stub_activities_success
    #activities second page to test loop
    stub_activities_success_page_2
    #enqueue create job with detailed activity 1
    stub_detailed_activities_success_1
    #enqueue create job with detailed activity 2
    stub_detailed_activities_success_2

    ActivitiesSyncJob.perform_now(@user_with_valid_refresh.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_enqueued_jobs 1
    assert_equal "Valid_Token", @user_with_valid_refresh.auth.reload.token
    assert_difference "Activity.count", 2 do
      perform_enqueued_jobs
    end
    assert_performed_jobs 3
  end

  test "Job ran with user with invalid auth should not be retried" do
    #first request will throw exception
    stub_activities_error
    #token refreshed after exception
    stub_refresh_token_error

    ActivitiesSyncJob.perform_now(@user_with_invalid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_enqueued_jobs 0
  end

  test "Job ran with user with valid auth should run" do
    stub_activities_success
    #activities second page to test loop
    stub_activities_success_page_2
    #enqueue create job with detailed activity 1
    stub_detailed_activities_success_1
    #enqueue create job with detailed activity 2
    stub_detailed_activities_success_2

    ActivitiesSyncJob.perform_now(@user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    assert_enqueued_jobs 2
    assert_difference "Activity.count", 2 do
      perform_enqueued_jobs
    end
    assert_performed_jobs 2
  end

  test "Job ran with user with valid auth but throttled should schedule job" do
    #first request is throttled
    stub_throttled

    assert_difference "Throttle.count", 1 do
      ActivitiesSyncJob.perform_now(@user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    end
    assert_enqueued_with(job: ActivitiesSyncJob, args: [@user_with_valid_auth.id, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"]], at: Time.now.utc.midnight.tomorrow)
  end
end

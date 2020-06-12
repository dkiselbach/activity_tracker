class ActivityUpdateJob < ApplicationJob
  include HttpRequest
  include CheckAuth
  queue_as :default
  rescue_from ApiExceptions::AuthenticationError do
    retry_job if refresh(@current_user, @client_id, @client_secret)
  end
  rescue_from ApiExceptions::RateLimitError do
    @current_user.throttle.create(hourly_usage: @response.header['X-RateLimit-Usage'].split(",").first, daily_usage: @response.header['X-RateLimit-Usage'].split(",").second, app_name: "Strava")
    retry_job(wait: @time) if throttled?
  end

  def perform(strava_id, user_id, strava_client_id, strava_client_secret)
    if Activity.exists?(strava_id: strava_id)

      if throttled?
        ActivityUpdateJob.set(wait: @time).perform_later(strava_id, user_id, strava_client_id, strava_client_secret)
        return
      end

      @current_user = User.find(user_id)
      @client_id = strava_client_id
      @client_secret = strava_client_secret
      url = "https://www.strava.com/api/v3/activities"
      results = get("#{url}/#{strava_id}?includeallefforts=false", @current_user.auth.token)
      Activity.find_by(strava_id: strava_id).update(distance: results["distance"],
        activity_time: results["moving_time"], avg_hr: results["average_heartrate"],
        activity_type: results["type"], name: results["name"], calories: results["calories"],
        laps: results["laps"].to_json,  splits: results["splits_standard"].to_json, splits_metric: results["splits_metric"].to_json, start_date_local: results["start_date_local"], speed: results["average_speed"])

      if results["type"] == "Run"
        results["best_efforts"].each do |results|
          if !results["pr_rank"].nil?
            @current_user.record.create(name: results["name"], distance: results["distance"], elapsed_time: results["elapsed_time"], moving_time: results["moving_time"], start_date_local: results["start_date_local"], pr_rank: results["pr_rank"], strava_id: strava_id)
          end
        end
      end
    end
  end
end

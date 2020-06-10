class ActivityCreateJob < ApplicationJob
  queue_as :default
  retry_on ApiExceptions::AuthenticationError, attempts: 1
  rescue_from ApiExceptions::AuthenticationError do
    refresh(@current_user, @client_id, @client_secret)
  end
  rescue_from ApiExceptions::RateLimitError do
    @current_user.throttle.create(hourlyusage: @response.header['X-RateLimit-Usage'].split(",").first, dailyusage: @response.header['X-RateLimit-Usage'].split(",").second, appname: "Strava")
  end

  def perform(strava_id, user_id, strava_client_id, strava_client_secret)
    if !Activity.exists?(strava_id: strava_id)

      if throttled?
        ActivityCreateJob.set(wait: @time).perform_later(strava_id, user_id, strava_client_id, strava_client_secret)
        return
      end

      @current_user = User.find(user_id)
      @client_id = strava_client_id
      @client_secret = strava_client_secret

      url = "https://www.strava.com/api/v3/activities"
      @results = get("#{url}/#{strava_id}?includeallefforts=false", @current_user.auth.token)
      @activity = @current_user.activity.build(strava_id: "#{@results["id"]}", distance: "#{@results["distance"]}",
        activity_time: "#{@results["moving_time"]}", avg_hr: "#{@results["average_heartrate"]}",
        activity_type: "#{@results["type"]}", name: "#{@results["name"]}", calories: "#{@results["calories"]}",
        laps: "#{@results["laps"].to_json}", splits: "#{@results["splits_standard"].to_json}",
        start_date_local: "#{@results["start_date_local"]}", speed: "#{@results["average_speed"]}")
      @activity.save
    end
  end
end

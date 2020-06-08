class ActivityCreateJob < ApplicationJob
  include HttpRequest
  include CheckAuth
  queue_as :default
  retry_on ApiExceptions::RateLimitError, wait: 15.minutes, attempts: 3
  retry_on ApiExceptions::AuthenticationError, wait: 1.minutes, attempts: 1

  def perform(strava_id, user_id, client_id, client_secret, auth_check = false)
    if !Activity.exists?(strava_id: strava_id)
      current_user = User.find(user_id)
      url = "https://www.strava.com/api/v3/activities"
      results = get("#{url}/#{strava_id}?includeallefforts=false", current_user.auth.token)
      @activity = current_user.activity.build(strava_id: "#{results["id"]}", distance: "#{results["distance"]}",
        activity_time: "#{results["moving_time"]}", avg_hr: "#{results["average_heartrate"]}",
        activity_type: "#{results["type"]}", name: "#{results["name"]}", calories: "#{results["calories"]}",
        laps: "#{results["laps"].to_json}", splits: "#{results["splits_standard"].to_json}",
        start_date_local: "#{results["start_date_local"]}", speed: "#{results["average_speed"]}")
      @activity.save
    end
  end
end

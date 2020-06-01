class ActivityCreateJob < ApplicationJob
  include HttpRequest
  include CheckAuth
  queue_as :default

  def perform(strava_id, user)
    if check_auth(user)
      url = "https://www.strava.com/api/v3/activities"
      results = get("#{url}/#{strava_id}?includeallefforts=false", user.auth.token)
      @activity = user.activity.build(strava_id: "#{results["id"]}", distance: "#{results["distance"]}",
        activity_time: "#{results["moving_time"]}", avg_hr: "#{results["average_heartrate"]}",
        activity_type: "#{results["type"]}", name: "#{results["name"]}", calories: "#{results["calories"]}",
        laps: "#{results["laps"].to_json}", splits: "#{results["splits_standard"].to_json}" )
      @activity.save
    end
  end
end

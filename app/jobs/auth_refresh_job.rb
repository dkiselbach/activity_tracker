class AuthRefreshJob < ApplicationJob
  include HttpRequest
  queue_as :default

  def perform(strava_client_id, strava_client_secret, strava_user_id)
    current_user = User.find_by(strava_id: strava_user_id)

    url = "https://www.strava.com/oauth/token"
    body = {
      "grant_type" =>  "refresh_token",
      "client_id" => "#{strava_client_id}",
      "client_secret" => "#{strava_client_secret}",
      "refresh_token" => "#{current_user.auth.refresh_token}"
    }

    results = post(url, body)
    current_user.auth.update(token: "#{results["access_token"]}", refresh_token: "#{results["refresh_token"]}")
  end
end

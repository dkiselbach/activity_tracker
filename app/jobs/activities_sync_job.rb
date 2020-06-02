class ActivitiesSyncJob < ApplicationJob
  include HttpRequest
  queue_as :default
  retry_on ApiExceptions::RateLimitError, wait: 15.minutes, attempts: 3

  def perform(user_id, client_id, client_secret)
    current_user = User.find(user_id)
    url = "https://www.strava.com/api/v3/athlete/activities?per_page=200"
    response = get(url, current_user.auth.token)

    response.each do |results|
      ActivityCreateJob.perform_later(results["id"], current_user.id,
        client_id, client_secret, auth_check = true)
    end
  end
end

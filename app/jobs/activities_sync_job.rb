class ActivitiesSyncJob < ApplicationJob
  include HttpRequest
  include CheckAuth
  queue_as :default
  retry_on ApiExceptions::RateLimitError, wait: 15.minutes, attempts: 3
  retry_on ApiExceptions::AuthenticationError, attempts: 1
  rescue_from ApiExceptions::AuthenticationError do
    refresh(@current_user, @client_id, @client_secret)
  end
  rescue_from ApiExceptions::RateLimitError do
    puts "This job will rety in 15 minutes"
  end

  def perform(user_id, strava_client_id, strava_client_secret)
    @current_user = User.find(user_id)
    @client_id = strava_client_id
    @client_secret = strava_client_secret

    url = "https://www.strava.com/api/v3/athlete/activities?per_page=200&page=1"
    response = get(url, @current_user.auth.token)
    page = 1

    while !response.empty?
      response.each do |results|
        ActivityCreateJob.set(wait: 1.minute).perform_later(results["id"], @current_user.id,
          @client_id, @client_secret)
      end
      page += 1
      url = "https://www.strava.com/api/v3/athlete/activities?per_page=200&page=#{page}"
      response = get(url, @current_user.auth.token)
    end
  end
end

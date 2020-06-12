class ActivitiesSyncJob < ApplicationJob
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

  def perform(user_id, strava_client_id, strava_client_secret)

    if throttled?
      ActivitiesSyncJob.set(wait: @time).perform_later(user_id, strava_client_id, strava_client_secret)
      return
    end

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

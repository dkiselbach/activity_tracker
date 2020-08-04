# frozen_string_literal: true

class BiometricsUpdateJob < ApplicationJob
  include HttpRequest
  include CheckAuth
  queue_as :default
  rescue_from ApiExceptions::AuthenticationError do
    retry_job if refresh(@current_user, @client_id, @client_secret)
  end
  rescue_from ApiExceptions::RateLimitError do
    @current_user.throttle.create(hourly_usage: @response.header['X-RateLimit-Usage'].split(',').first, daily_usage: @response.header['X-RateLimit-Usage'].split(',').second, app_name: 'Strava')
    retry_job(wait: @time) if throttled?
  end

  def perform(biometrics_id, weight, user_id, strava_client_id, strava_client_secret)
    if throttled?
      BiometricsUpdateJob.set(wait: @time).perform_later(biometrics_id, weight, user_id,
                                                         strava_client_id, strava_client_secret)
      return
    end

    @current_user = User.find(user_id)
    @client_id = strava_client_id
    @client_secret = strava_client_secret

    url = 'https://www.strava.com/api/v3/athlete'
    body = { 'weight' => weight }

    put(url, body, @current_user.auth.token)
    Biometric.find(biometrics_id).toggle!(:strava_updated) if @success
  end
end

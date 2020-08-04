# frozen_string_literal: true

module CheckAuth
  extend ActiveSupport::Concern
  include HttpRequest

  def check_auth(user, _client_id, _client_secret)
    return @success = 'Strava auth is valid but api is rate limited' if user.auth && throttled?

    if user.auth
      test_url = 'https://www.strava.com/api/v3/athlete'
      get(test_url, user.auth.token)
      @success = 'Strava auth is valid' if @response.code == '200'
    else
      @error = { type: 'auth', message: 'User has no auth' }
    end
  rescue ApiExceptions::RateLimitError
    hourly_usage = @response.header['X-RateLimit-Usage'].split(',').first
    daily_usage = @response.header['X-RateLimit-Usage'].split(',').second
    user.throttle.create(hourly_usage: hourly_usage, daily_usage: daily_usage, app_name: 'Strava')
    @success = 'Strava auth is valid but api is rate limited'
  end

  def refresh(user, client_id, client_secret)
    url = 'https://www.strava.com/oauth/token'
    body = {
      'grant_type' => 'refresh_token',
      'client_id' => client_id.to_s,
      'client_secret' => client_secret.to_s,
      'refresh_token' => user.auth.refresh_token.to_s
    }

    post(url, body)
    if @success
      user.auth.update(token: (@success['access_token']).to_s, refresh_token: (@success['refresh_token']).to_s)
    else
      false
    end
  end

  def throttled?
    @throttle = Throttle.last
    @time = @throttle.limited?
  end
end

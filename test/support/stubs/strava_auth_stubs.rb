# frozen_string_literal: true

module StravaAuthStubs
  # when initial auth is succesful
  def stub_auth_request_success(options = {})
    url = 'https://www.strava.com/oauth/token'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('auth_request_success.json'))
    stub_request(:post, url)
      .with(
        body: { 'client_id' => ENV['STRAVA_CLIENT_ID'], 'client_secret' => ENV['STRAVA_CLIENT_SECRET'], 'code' => 'Valid_Code', 'grant_type' => 'authorization_code' },
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  # when a refresh token is succesfully refreshed
  def stub_refresh_token_success(options = {})
    url = 'https://www.strava.com/oauth/token'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('refresh_token_success.json'))
    stub_request(:post, url).with(
      body: { 'client_id' => ENV['STRAVA_CLIENT_ID'], 'client_secret' => ENV['STRAVA_CLIENT_SECRET'], 'grant_type' => 'refresh_token', 'refresh_token' => 'Valid_Refresh' },
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end

  # when an integration is succesfully deauthorized
  def stub_deauthorize_success(options = {})
    url = 'https://www.strava.com/oauth/deauthorize'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('auth_deactivation_success.json'))
    stub_request(:post, url).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer Valid_Token',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end

  # when an auth check is successful
  def stub_athlete_auth_success(options = {})
    url = 'https://www.strava.com/api/v3/athlete'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('athlete_auth_success.json'))
    stub_request(:get, url).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer Valid_Token',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end

  # when initial auth is unsuccesful due to invalid code
  def stub_auth_request_error(options = {})
    url = 'https://www.strava.com/oauth/token'
    status = options.fetch(:status, 400)
    response_body = options.fetch(:response_body,
                                  json_string('auth_request_failure.json'))
    stub_request(:post, url)
      .with(
        body: { 'client_id' => ENV['STRAVA_CLIENT_ID'], 'client_secret' => ENV['STRAVA_CLIENT_SECRET'], 'code' => 'Invalid_Code', 'grant_type' => 'authorization_code' },
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  # when a refresh request is unsuccesful due to invalid refresh
  def stub_refresh_token_error(options = {})
    url = 'https://www.strava.com/oauth/token'
    status = options.fetch(:status, 400)
    response_body = options.fetch(:response_body,
                                  json_string('refresh_token_error.json'))
    stub_request(:post, url).with(
      body: { 'client_id' => ENV['STRAVA_CLIENT_ID'], 'client_secret' => ENV['STRAVA_CLIENT_SECRET'], 'grant_type' => 'refresh_token', 'refresh_token' => 'Invalid_Refresh' },
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end

  # when an auth check is unsuccesful due to a invalid token
  def stub_athlete_auth_error(options = {})
    url = 'https://www.strava.com/api/v3/athlete'
    status = options.fetch(:status, 401)
    response_body = options.fetch(:response_body,
                                  json_string('athlete_auth_error.json'))
    stub_request(:get, url).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer Invalid_Token',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end

  # when an integration deauthorization is unsuccessful
  def stub_deauthorize_failure(options = {})
    url = 'https://www.strava.com/oauth/deauthorize'
    status = options.fetch(:status, 401)
    response_body = options.fetch(:response_body,
                                  json_string('auth_deactivation_failure.json'))
    stub_request(:post, url).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer Invalid_Token',
        'Host' => 'www.strava.com',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: status, body: response_body)
  end
end

# frozen_string_literal: true

module HttpRequestHelper
  include JSONFixtures

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

  def stub_activities_success(options = {})
    url = 'https://www.strava.com/api/v3/athlete/activities?per_page=200&page=1'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('activities_success.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  def stub_activities_success_page_2(options = {})
    url = 'https://www.strava.com/api/v3/athlete/activities?per_page=200&page=2'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('activities_success_page_2.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  def stub_detailed_activities_success_1(options = {})
    url = 'https://www.strava.com/api/v3/activities/3447675367?includeallefforts=false'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('detailed_activities_success_3447675367.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  def stub_detailed_activities_success_2(options = {})
    url = 'https://www.strava.com/api/v3/activities/3457608300?includeallefforts=false'
    status = options.fetch(:status, 200)
    response_body = options.fetch(:response_body,
                                  json_string('detailed_activities_success_3457608300.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  def stub_throttled(options = {})
    url = 'https://www.strava.com/api/v3/athlete/activities?per_page=200&page=1'
    status = options.fetch(:status, 429)
    headers = { 'X-RateLimit-Usage': '101,1001' }
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, headers: headers)
  end

  def stub_throttled_1(options = {})
    url = 'https://www.strava.com/api/v3/activities/3447675367?includeallefforts=false'
    status = options.fetch(:status, 429)
    headers = { 'X-RateLimit-Usage': '101,1001' }
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, headers: headers)
  end

  def stub_throttled_2(options = {})
    url = 'https://www.strava.com/api/v3/activities/3457608300?includeallefforts=false'
    status = options.fetch(:status, 429)
    headers = { 'X-RateLimit-Usage': '101,1001' }
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, headers: headers)
  end

  def stub_athlete_auth_throttled(options = {})
    url = 'https://www.strava.com/api/v3/athlete'
    status = options.fetch(:status, 429)
    headers = { 'X-RateLimit-Usage': '101,1001' }
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Valid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, headers: headers)
  end

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

  def stub_activities_error(options = {})
    url = 'https://www.strava.com/api/v3/athlete/activities?per_page=200&page=1'
    status = options.fetch(:status, 401)
    response_body = options.fetch(:response_body,
                                  json_string('athlete_auth_error.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Invalid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

  def stub_detailed_activities_error_1(options = {})
    url = 'https://www.strava.com/api/v3/activities/3447675367?includeallefforts=false'
    status = options.fetch(:status, 401)
    response_body = options.fetch(:response_body,
                                  json_string('athlete_auth_error.json'))
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer Invalid_Token',
          'Host' => 'www.strava.com',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: status, body: response_body)
  end

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
end

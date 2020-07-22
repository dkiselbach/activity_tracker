# frozen_string_literal: true

module StravaThrottledStubs
  # throttled response for activities index
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

  # throttled response for activity 1 show
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

  # throttled resposne for activity 2 show
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

  # throttled for auth check
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
end

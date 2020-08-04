# frozen_string_literal: true

module StravaActivitiesStubs
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
end

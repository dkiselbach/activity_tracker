module HttpRequestHelper
  include JSONFixtures

  def stub_athlete_auth_error(options = {})
    url = "https://www.strava.com/api/v3/athlete"
    status = options.fetch(:status, 401)
    response_body = options.fetch(:response_body,
                                  json_string("athlete_auth_error.json"))
    stub_request(:get, url).with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'Bearer Invalid_Token',
      'Host'=>'www.strava.com',
      'User-Agent'=>'Ruby'
      }).to_return(status: status, body: response_body)
  end

  def stub_refresh_token_error(options = {})
    url = "https://www.strava.com/oauth/token"
    status = options.fetch(:status, 400)
    response_body = options.fetch(:response_body,
                                  json_string("refresh_token_error.json"))
    stub_request(:post, url).with(
      body: {"client_id"=>"", "client_secret"=>"", "grant_type"=>"refresh_token", "refresh_token"=>"Invalid_Refresh"},
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'Host'=>'www.strava.com',
      'User-Agent'=>'Ruby'
      }).to_return(status: status, body: response_body)
  end
end

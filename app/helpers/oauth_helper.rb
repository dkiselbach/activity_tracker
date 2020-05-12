module OauthHelper
require 'oauth2'
require 'net/http'

  def oauth_client
    #set the oauth client
    oauth_client = OAuth2::Client.new(ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'],
      :site => ENV['STRAVA_SITE_BASE'], :max_redirects => 5 )
  end

  def authorize
    #get the authorization url
    @authorize_url = oauth_client.auth_code.authorize_url(:redirect_uri => oauth_strava_auth_code_url) + '&scope=activity:read'
    # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
  end

  def access_token(code)
    #set the access token
    @token = oauth_client.auth_code.get_token(code, :redirect_uri => oauth_strava_auth_code_url)
  end

  def check_auth
    test_url = ENV['STRAVA_SITE_BASE'] + '/api/v3/athlete/activities'
    response = get(test_url)
    return if response.code == '200'
    refresh_token
  end

  def refresh_token
  end

  def get(path)
    @token.get(path)
  end

  def post(path)
    @token.post(path)
  end
end

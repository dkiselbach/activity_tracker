module OauthHelper
require 'oauth2'

  def authorize
      #set oauth client
      @oauth_client = OAuth2::Client.new(ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_CLIENT_SECRET'],
        :site => ENV['STRAVA_SITE_BASE'], :max_redirects => 5 )

      #get the authorization url
      @authorize_url=@oauth_client.auth_code.authorize_url(:redirect_uri => oauth_strava_auth_code_url) + '&scope=activity:read'
      # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
  end

  def authorize_test
      @authorize_url = "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
  end
end

class Auth < ApplicationRecord
  belongs_to :user
  validates :app_name, :token, presence: true
  #attr_accessor :code, :token, :refresh_token


  def access_token(code, redirect_uri)

    url = "#{ENV['STRAVA_SITE_BASE']}/oauth/token"
    uri = URI.parse(url)

    request = Net::HTTP::Post.new(uri)
    request.set_form_data({
      "grant_type" =>  "authorization_code",
      "code" => "#{code}",
      "client_id" => "#{ENV['STRAVA_CLIENT_ID']}",
      "client_secret" => "#{ENV['STRAVA_CLIENT_SECRET']}",
      "redirect_uri" => "#{redirect_uri}"
    })

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if 'https' == uri.scheme

    response = http.request(request)

    if response.code == '200'
      response = JSON.parse(response.body)
      self.update(app_name: "Strava", token: "#{response["access_token"]}", refresh_token: "#{response["refresh_token"]}")
    else
      return false
    end
  end

#  def Auth.access_token(code, redirect_uri)
    #set the access token
  #  @token = Auth.oauth_client.auth_code.get_token(code, :redirect_uri => redirect_uri)
    #update_columns(activated: true, activated_at: Time.zone.now)
#  end

  def check_auth
    test_url = ENV['STRAVA_SITE_BASE'] + '/api/v3/athlete/activities'
    response = get(test_url)
    return if response.code == '200'
    refresh_token
  end

  def refresh_token
  end
end

class Auth < ApplicationRecord
  include HttpRequest
  belongs_to :user
  validates :app_name, :token, presence: true

  def access(code, redirect_uri)

    url = "#{ENV['STRAVA_SITE_BASE']}/oauth/token"
    body = {
      "grant_type" =>  "authorization_code",
      "code" => "#{code}",
      "client_id" => "#{ENV['STRAVA_CLIENT_ID']}",
      "client_secret" => "#{ENV['STRAVA_CLIENT_SECRET']}",
      "redirect_uri" => "#{redirect_uri}"
    }

    post(url, body)
      if @success
        self.update(app_name: "Strava", token: "#{@success["access_token"]}", refresh_token: "#{@success["refresh_token"]}")
      else
        return false
      end
  end

  def refresh
    url = "#{ENV['STRAVA_SITE_BASE']}/oauth/token"
    body = {
      "grant_type" =>  "refresh_token",
      "client_id" => "#{ENV['STRAVA_CLIENT_ID']}",
      "client_secret" => "#{ENV['STRAVA_CLIENT_SECRET']}",
      "refresh_token" => "#{refresh_token}"
    }

    post(url, body)
      if @success
        self.update(token: "#{@success["access_token"]}", refresh_token: "#{@success["refresh_token"]}")
      else
        return false
      end
  end

  def check
    test_url = "#{ENV['STRAVA_SITE_BASE']}/api/v3/athlete"
    get(test_url, self.token)
    if @response.code == '200'
      return true
    else
      self.refresh
    end
  end
end

module AuthHelper

  def auth_url
    @auth_url = "#{ENV['STRAVA_SITE_BASE']}/oauth/authorize?client_id=#{ENV['STRAVA_CLIENT_ID']}&redirect_uri=#{auth_strava_code_url}&response_type=code&scope=activity:read"
  end
end

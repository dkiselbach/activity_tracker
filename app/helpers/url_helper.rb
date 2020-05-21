module UrlHelper

  def auth_url
    @auth_url = "#{ENV['STRAVA_SITE_BASE']}/oauth/authorize?client_id=#{ENV['STRAVA_CLIENT_ID']}&redirect_uri=#{auth_strava_code_url}&response_type=code&scope=activity:read"
  end

  def url_builder(query_string)
    params = query_string
    url = "#{ENV['SITE_BASE']}?#{params.to_query}"
  end
end

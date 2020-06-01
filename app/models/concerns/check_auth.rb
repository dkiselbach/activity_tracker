module CheckAuth
  extend ActiveSupport::Concern
  include HttpRequest

  def check_auth(user = current_user)
    if user.auth
      test_url = "https://www.strava.com/api/v3/athlete"
      get(test_url, user.auth.token)
        if @response.code == '200'
          return true
        else
          if refresh(user)
            @success = "Strava auth refreshed"
          else
            @error = "Tokens are invalid"
          end
        end
    else
      @error = "User has no Auth"
    end
  end

  def refresh(user)
    url = "https://www.strava.com/oauth/token"
    body = {
      "grant_type" =>  "refresh_token",
      "client_id" => "#{ENV['STRAVA_CLIENT_ID']}",
      "client_secret" => "#{ENV['STRAVA_CLIENT_SECRET']}",
      "refresh_token" => "#{user.auth.refresh_token}"
    }

    post(url, body)
      if @success
        user.auth.update(token: "#{@success["access_token"]}", refresh_token: "#{@success["refresh_token"]}")
      else
        return false
      end
  end
end

module CheckAuth
  extend ActiveSupport::Concern
  include HttpRequest

  def check_auth(user = current_user, client_id, client_secret)
    if user.auth
      test_url = "https://www.strava.com/api/v3/athlete"
      get(test_url, user.auth.token)
        if @response.code == '200'
          @success = "Strava auth is valid"
        #elsif refresh(user, client_id, client_secret)
        #  @success = "Strava auth refreshed"
        #else
        #  @error = {:type => "token", :message => "Tokens are invalid"}
        end
    else
      @error = {:type => "auth", :message => "User has no auth"}
    end
  end

  def refresh(user, client_id, client_secret)
    url = "https://www.strava.com/oauth/token"
    body = {
      "grant_type" =>  "refresh_token",
      "client_id" => "#{client_id}",
      "client_secret" => "#{client_secret}",
      "refresh_token" => "#{user.auth.refresh_token}"
    }

    post(url, body)
      if @success
        user.auth.update(token: "#{@success["access_token"]}", refresh_token: "#{@success["refresh_token"]}")
      else
        return false
      end
  end

  def throttled?
    @throttle = Throttle.last
    if @throttle.limit_type == "daily"
      if Time.now.utc.to_date > @throttle.created_at.utc.to_date
        return false
      else
        @time = ((Time.now.utc.midnight.tomorrow - Time.now.utc)/60).minutes
      end
    elsif @throttle.limit_type == "15-minute"
      if Time.now.utc > @throttle.created_at.utc + 15 * 60
        return false
      else
        @time = (((@throttle.created_at.utc + 15 * 60) - Time.now.utc)/60).minutes
      end
    end
  end
end

class ActivityController < ApplicationController
  include HttpRequest
  before_action :authenticate_user!
  before_action :check_token

  def create
    url = "#{ENV['STRAVA_SITE_BASE']}/api/v3/athlete/activities"

    @results = get(url, current_user.auth.token)
    @results.each do |i|
      @activity = current_user.activity.build.set_results(i)
    end
      render :status => 200,
             :json => { :success => ["Activities synced"]}
  end

  private

    def check_token
      if current_user.auth
        if current_user.auth.check == false
          render :status => :unprocessable_entity,
                 :json => { :error => ["Something went wrong with your authentication. Please connect to Strava again."] }
        end
      else
        render :status => :unprocessable_entity,
               :json => { :error => ["Connect to Strava first before syncing your activities."] }
      end
    end
end

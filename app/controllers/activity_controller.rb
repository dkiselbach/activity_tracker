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
      flash[:success] = "Your activities were synced succesfully"
      redirect_to sync_activities_path
  end

  private

    def check_token
      if current_user.auth
        if current_user.auth.check == false
          flash[:danger] = "Something went wrong with your authentication. Please connect to Strava again."
          redirect_to setup_path
        end
      else
        flash[:danger] = "Connect to Strava first before syncing your activities."
        redirect_to setup_path
      end
    end
end

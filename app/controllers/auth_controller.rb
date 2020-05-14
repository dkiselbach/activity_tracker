class AuthController < ApplicationController
  before_action :authenticate_user!

  def create
    @auth = current_user.build_auth()
    if params[:code].present? && params[:scope] == "read,activity:read"
      if @auth.access(params[:code], auth_strava_code_url)
        flash[:success] = "Strava has successfully connected."
        redirect_to root_path
      else
        flash[:danger] = "There was an issue with the authorization. Please try again."
        redirect_to setup_path
      end
    else
      flash[:danger] = "You need to authorize the integration from Strava. Please try again, and ensure to include
      activities in the authentication."
      redirect_to setup_path
    end
  end
end

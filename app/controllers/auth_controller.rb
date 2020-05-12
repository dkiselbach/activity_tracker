class AuthController < ApplicationController
  before_action :authenticate_user!

  def authorize
  end

  def access
  end

  def refresh
  end

  def code
    @auth = current_user.build_auth()
    if current_user && params[:code].present? && @auth.access_token(params[:code], auth_strava_code_url)
      @auth.save
      flash[:success] = "Strava has successfully connected."
      redirect_to root_path
    else
      flash[:danger] = "There was an issue with the authorization. Please try again."
      redirect_to setup_path
    end
  end
end

class OauthController < ApplicationController
  before_action :authenticate_user!

  def authorize
  end

  def access
  end

  def refresh
  end

  def auth_code
    if current_user && params[:code].present?
      helpers.access_token(params[:code])
      flash[:success] = "Strava has successfully connected."
      redirect_to root_path
    else
      redirect_to setup_path
    end
  end
end

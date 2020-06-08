class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  #skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :html, :json
  rescue_from ApiExceptions::AuthenticationError, with: :refresh_auth

  def refresh_auth
    if refresh(current_user, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
      render :status => '200',
             :json => { :success => ["Strava Auth was refreshed"] }
    else
      render :status => :unprocessable_entity,
             :json => { :error => { :refresh_token => ["Refresh Token is invalid"] }}
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  #skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :html, :json

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

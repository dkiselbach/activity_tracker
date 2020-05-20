class User::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  before_action :configure_sign_up_params, only: [:create]
  after_action -> { request.session_options[:skip] = true }
  wrap_parameters :user

  def create
    build_resource(sign_up_params)
    if resource.save
      render  :json => { :success => true,
                        :info => "Registered",
                        :email => resource.email }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors }
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
end

class User::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :update
  after_action -> { request.session_options[:skip] = true }

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :status => 200,
             :json => { :success => true,
                        :info => "email sent",
                        :email => resource.email }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors }
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(params[:users])
    if resource.errors.empty?
      render  :status => 200,
              :json => { :success => true,
                        :info => "Password reset",
                        :email => resource.email }
    else
      render :status => :unauthorized,
             :json => { :success => false,
                        :info => resource.errors }
    end
  end

  protected

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:users][:reset_password_token].blank?
        render :status => :unprocessable_entity,
               :json => { :success => false,
                          :info => "Reset password token cannot be blank." }
      end
    end
end

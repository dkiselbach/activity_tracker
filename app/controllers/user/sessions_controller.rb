class User::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :failure]
  after_action -> { request.session_options[:skip] = true }
  wrap_parameters :user

  def create
      warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      render :json => { :success => true,
                        :info => "Login successful" }
  end

  def failure
    render :status => :unauthorized,
           :json => { :success => false,
                      :info => "Login failed" }
  end
end

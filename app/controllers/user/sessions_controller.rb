class User::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :failure]
  after_action -> { request.session_options[:skip] = true }
  wrap_parameters :user

  def create
      self.resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      render :status => 200,
             :json => { :success => true,
                        :info => "Login successful",
                        :email => resource.email,
                        :name => resource.name}
  end

  def failure
    if User.find_by(email: sign_in_params[:email])
      render :status => :unauthorized,
             :json => { :success => false,
                        :info => "The password you’ve entered is incorrect." }
    else
      render :status => :unauthorized,
             :json => { :success => false,
                        :info => "The email you’ve entered doesn’t match any account." }
    end
  end
end

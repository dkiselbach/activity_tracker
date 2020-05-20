class User::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :failure]
  after_action -> { request.session_options[:skip] = true }
  wrap_parameters :user

  def create
      self.resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      render :status => 200,
             :json => { :success => "Login successful",
                        :email => resource.email,
                        :name => resource.name}
  end

  def failure
    if User.find_by(email: sign_in_params[:email])
      render :status => :unauthorized,
             :json => { :error => { :password => "doesn't match Password" }}
    else
      render :status => :unauthorized,
             :json => { :error => { :email => "Email doesn't exist" } }
    end
  end
end

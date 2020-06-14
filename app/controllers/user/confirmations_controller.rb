class User::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :verify_authenticity_token, only: [:create, :show]
  wrap_parameters :user

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      render :status => 200,
             :json => { :success => ["Email sent"],
                        :email => [resource.email] }
    else
      render :status => :unauthorized,
             :json => { :error => resource.errors }
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      render :status => 200,
             :json => { :success => ["User confirmed"],
                        :email => [resource.email] }
    else
      render :status => :unauthorized,
             :json => { :error => resource.errors }
    end
  end
end

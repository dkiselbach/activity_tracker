class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    render :json => current_user.as_json.merge(:profile_image => profile_image_url)
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :weight, :height)
    end

    def profile_image_url
      url_for(current_user.image)
    end
end

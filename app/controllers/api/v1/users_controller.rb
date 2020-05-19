class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
   @user = current_user
   render json: @user
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email)
    end
end

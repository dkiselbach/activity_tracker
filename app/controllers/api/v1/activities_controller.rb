class Api::V1::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:activity_type].present?
     @activities = current_user.activity.where(activity_type: params[:activity_type]).page(params[:page])
     render json: @activities
    else
     @activities = current_user.activity.page(params[:page])
     render json: @activities
    end
  end

  def show
    @activity = current_user.activity.find(params[:id])
    render json: @activity
  end

  def update
    @activity = current_user.activity.find(params[:id])
    if @activity.update(activity_params)
      render json: @activity
    end
  end

  private

    def activity_params
      params.require(:activity).permit(:name, :distance, :avg_hr,
                          :calories, :activity_time)
    end
end

class Api::V1::ActivitiesController < ApplicationController
  include HttpRequest
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :check_token, only: [:create]

  def index
    if params[:activity_type].present?
     @activities = current_user.activity.where(activity_type: params[:activity_type]).page(params[:page])
     render json: @activities
    else
     @activities = current_user.activity.page(params[:page])
     render json: @activities
    end
  end

  def create
    url = "#{ENV['STRAVA_SITE_BASE']}/api/v3/athlete/activities"

    @results = get(url, current_user.auth.token)
    @results.each do |i|
      @activity = current_user.activity.build.set_results(i)
    end
      render :status => 200,
             :json => { :success => ["Activities synced"]}
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

    def check_token
      if current_user.auth
        if current_user.auth.check == false
          render :status => :unprocessable_entity,
                 :json => { :error => { :token => ["Tokens are invalid" ]} }
        end
      else
        render :status => :unprocessable_entity,
               :json => { :error => { :auth => ["User has no Auth" ]} }
      end
    end
end

class Api::V1::ActivitiesController < ApplicationController
  include HttpRequest
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :check_auth, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :activity_not_found

  def index
   @activities = current_user.activity.exclude_laps_splits.reorder("created_at DESC").page(params[:page])
   @current_page = params[:page].to_i if params[:page]
   render :json => { "pagination" =>{
                                     "current_page": @current_page || 1,
                                     "total_pages": @activities.total_pages,
                                     "total": @activities.count},
                     "activities" => @activities
                   }
  end

  def create
    url = "#{ENV['STRAVA_SITE_BASE']}/api/v3/athlete/activities"
    detailed_url = "#{ENV['STRAVA_SITE_BASE']}/api/v3/activities"

    response = get(url, current_user.auth.token)

    response.each do |results|
      @activity = current_user.activity.build
      if @activity.set_results(results)
        detailed_results = get("#{detailed_url}/#{results["id"]}?includeallefforts=false", current_user.auth.token)
        @activity.set_detailed_results(detailed_results)
      end
    end
      render :status => 200,
             :json => { :success => ["Activities synced"]}
  end

  def show
    @activity = current_user.activity.find(params[:id])
    @activity_details = current_user.activity.exclude_laps_splits.find(params[:id])

    @activity.laps.blank? || @activity.laps == "null" ? @laps = "No lap data" : @laps = JSON.parse(@activity.laps)
    @activity.splits.blank? || @activity.laps == "null" ? @splits = "No split data" : @splits = JSON.parse(@activity.splits)

    render :json => { "activity" => @activity_details,
                      "laps" => @laps,
                      "splits" => @splits}
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

    def activity_not_found
      render  :status => 404,
              :json => { :error => { :activity => ["does not exist or the user doesn't have access"] } }
    end
end

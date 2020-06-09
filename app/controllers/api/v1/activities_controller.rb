class Api::V1::ActivitiesController < ApplicationController
  include HttpRequest
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :activity_not_found

  def index
    if params[:start_date] && params[:end_date]
      start_date = params[:start_date]
      end_date = params[:end_date]
      activities = current_user.activity.exclude_laps_splits.where('start_date_local BETWEEN ? AND ?', start_date, end_date).reorder("start_date_local DESC")
    else
      activities = current_user.activity.exclude_laps_splits.reorder("start_date_local DESC")
    end
    if params[:page]
      @activities = activities.page(params[:page])
      @current_page = params[:page].to_i if params[:page]
     render :json => { "pagination" =>{
                                       "current_page": @current_page || 1,
                                       "total_pages": @activities.total_pages,
                                       "total": @activities.count},
                       "activities" => @activities
                     }
    else
      @activities = activities
      render :json => {"activities" => @activities}
    end
  end

  def create
    check_auth(current_user, ENV["STRAVA_CLIENT_ID"], ENV["STRAVA_CLIENT_SECRET"])
    if @success
      ActivitiesSyncJob.perform_later(current_user.id, ENV["STRAVA_CLIENT_ID"],
        ENV["STRAVA_CLIENT_SECRET"])

      render :status => 200,
             :json => { :success => ["Activities synced"]}
    else
      render :status => 401,
             :json => { :error => { :auth => ["#{@error}"] }}
    end
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

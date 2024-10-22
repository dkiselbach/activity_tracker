# frozen_string_literal: true

class Api::V1::ActivitiesController < ApplicationController
  include HttpRequest
  include CheckAuth
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :activity_not_found

  def index
    activities = if params[:include_followers]
                   current_user.feed
                 else
                   current_user.activity.exclude_laps_splits
                 end

    if params[:start_date] && params[:end_date]
      start_date = params[:start_date].to_datetime
      end_date = params[:end_date].to_datetime
      index = activities.where('start_date_local BETWEEN ? AND ?', start_date, end_date).reorder('start_date_local DESC')
    elsif params[:start_date]
      start_date = params[:start_date].to_datetime
      index = activities.where('start_date_local > ?', start_date).reorder('start_date_local DESC')
    else
      index = activities.reorder('start_date_local DESC')
    end

    if params[:page]
      @activities = index.page(params[:page])
      @current_page = params[:page].to_i
      render json: { 'pagination' => {
        "current_page": @current_page,
        "total_pages": @activities.total_pages,
        "total": @activities.count
      },
                     'activities' => @activities }
    else
      @activities = index
      render json: { 'activities' => @activities }
    end
  end

  def create
    if current_user.auth
      ActivitiesSyncJob.perform_later(current_user.id, ENV['STRAVA_CLIENT_ID'],
                                      ENV['STRAVA_CLIENT_SECRET'])

      render status: 200,
             json: { success: ['Activities synced'] }
    else
      render status: :unprocessable_entity,
             json: { error: { auth: ['User has no Auth'] } }
    end
  end

  def show
    @activity_details = current_user.feed.find(params[:id])
    @activity = Activity.find(params[:id])

    @laps = @activity.laps.blank? || @activity.laps == 'null' ? 'No lap data' : JSON.parse(@activity.laps)
    @activity.splits.blank? || @activity.splits == 'null' ? @splits = 'No split data' : @splits = JSON.parse(@activity.splits)
    @activity.splits_metric.blank? || @activity.splits_metric == 'null' ? @splits_metric = 'No split data' : @splits_metric = JSON.parse(@activity.splits_metric)

    render json: { 'activity' => @activity_details,
                   'laps' => @laps,
                   'splits' => @splits,
                   'splits_metric' => @splits_metric }
  end

  def update
    @activity = current_user.activity.find(params[:id])
    render json: @activity if @activity.update(activity_params)
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :distance, :avg_hr,
                                     :calories, :activity_time)
  end

  def activity_not_found
    render  status: 404,
            json: { error: { activity: ["does not exist or the user doesn't have access"] } }
  end
end

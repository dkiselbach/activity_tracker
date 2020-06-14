class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    @user = current_user
    longest_run = @user.activity.exclude_laps_splits.where(activity_type: "Run").order("distance DESC").first
    longest_ride = @user.activity.exclude_laps_splits.where(activity_type: "Ride").order("distance DESC").first
    fastest_half_marathon = @user.record.where(name: "Half-Marathon").where(pr_rank: 1).order("start_date_local DESC")
    fastest_10k = @user.record.where(name: "10k").where(pr_rank: 1).order("start_date_local DESC")
    @user.image.attached? ? profile_image = profile_image_url : profile_image = nil
    render :json => @user.as_json.merge(:longest_run => longest_run, :longest_ride => longest_ride, :fastest_half_marathon => fastest_half_marathon[0], :fastest_10k => fastest_10k[0], :profile_image => profile_image)
  end

  def show
    @user = User.find(params[:id])
    longest_run = @user.activity.exclude_laps_splits.where(activity_type: "Run").order("distance DESC").first
    longest_ride = @user.activity.exclude_laps_splits.where(activity_type: "Ride").order("distance DESC").first
    fastest_half_marathon = @user.record.where(name: "Half-Marathon").where(pr_rank: 1).order("start_date_local DESC")
    fastest_10k = @user.record.where(name: "10k").where(pr_rank: 1).order("start_date_local DESC")
    @user.image.attached? ? profile_image = profile_image_url : profile_image = nil
    #fastest_5k = Activity.exclude_laps_splits.where(activity_type: "Run").where("distance > ?", 20960).order("speed DESC").first
    render :json => @user.as_json.merge(:longest_run => longest_run, :longest_ride => longest_ride, :fastest_half_marathon => fastest_half_marathon[0], :fastest_10k => fastest_10k[0], :profile_image => profile_image)
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

    def profile_image_url
      url_for(current_user.image)
    end
end

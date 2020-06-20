class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :user_error

  def create
    if params[:follower_id].to_i != current_user.id
      render :status => :unprocessable_entity,
             :json => { :error => { :user_id => ["does not match authenticated User"] } }
      return
    end

    followed_user = User.find(params[:followed_id]) if params[:followed_id]
    if !current_user.following?(followed_user)
      current_user.follow(followed_user)
      render :status => 200,
             :json => { :success => ["User successfully followed"]}
    elsif params[:followed_id]
      render :status => :unprocessable_entity,
             :json => { :error => { :user => ["User is already followed"]} }
    else
      render :status => :unprocessable_entity,
             :json => { :error => { :followed_id => ["is blank"] } }
    end
  end

  def destroy
    if params[:id].to_i != current_user.id
      render :status => :unprocessable_entity,
             :json => { :error => { :user_id => ["does not match authenticated User"] } }
      return
    end

    followed_user = User.find(params[:followed_id]) if params[:followed_id]
    if current_user.following?(followed_user)
      current_user.unfollow(followed_user)
      render :status => 200,
             :json => { :success => ["User successfully unfollowed"]}
    elsif params[:followed_id]
     render :status => :unprocessable_entity,
            :json => { :error => { :user => ["User is not currently followed"]} }
    else
     render :status => :unprocessable_entity,
            :json => { :error => { :followed_id => ["is blank"] } }
    end
  end

  def index
    users = User.all.map { |user| user.image.attached? ? user.as_json.merge(:profile_image => profile_image_url) : user.as_json.merge(:profile_image => nil) }

    if params[:page]
      users = User.all.page(params[:page])
      index = users.map { |user| user.image.attached? ? user.as_json.merge(:profile_image => profile_image_url) : user.as_json.merge(:profile_image => nil) }
      current_page = params[:page].to_i
     render :json => { "pagination" =>{
                                       "current_page": current_page,
                                       "total_pages": users.total_pages,
                                       "total": index.count},
                       "users" => index
                     }
    return
    end
    render :json => users
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
    if current_user == User.find(params[:id])
      if current_user.update(user_params)
        render json: current_user
      else
        render :status => :unprocessable_entity,
               :json => { :error => { :params => JSON.parse(current_user.errors.messages.to_json)} }
      end
    else
      user_error
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :weight, :height)
    end

    def profile_image_url
      url_for(current_user.image)
    end

    def user_error
      render  :status => 404,
              :json => { :error => { :user => ["does not exist or the user doesn't have access"] } }
    end
end

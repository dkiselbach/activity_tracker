class Api::V1::ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    @profiles = current_user.profile.reorder("created_at DESC")
    render :status => 200,
           :json => { :profiles => @profiles}
  end

  def create
    @profile = current_user.profile.build(profile_params)
    if @profile.save
      render :status => 200,
             :json => { :success => ["Profile created"]}
    else
      render :status => :unprocessable_entity,
             :json => { :error => { :params => JSON.parse(@profile.errors.messages.to_json)} }
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:weight, :height)
    end
end

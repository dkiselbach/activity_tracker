class Api::V1::BiometricsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    @biometrics = current_user.biometric.reorder("created_at DESC")
    render :status => 200,
           :json => { :biometrics => @biometrics}
  end

  def create
    @biometrics = current_user.biometric.build(biometric_params)
    if @biometrics.save
      render :status => 200,
             :json => { :success => ["Biometrics created"]}
    else
      render :status => :unprocessable_entity,
             :json => { :error => { :params => JSON.parse(@biometrics.errors.messages.to_json)} }
    end
  end

  private

    def biometric_params
      params.require(:biometrics).permit(:weight)
    end
end

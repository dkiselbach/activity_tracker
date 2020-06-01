class ActivityDeleteJob < ApplicationJob
  queue_as :default

  def perform(strava_id)
    Activity.find_by(strava_id: strava_id).destroy
  end
end

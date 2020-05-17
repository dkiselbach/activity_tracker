class Activity < ApplicationRecord
  belongs_to :user
  validates :strava_id, :user_id, presence: true
  validates_uniqueness_of :strava_id

  def set_results(results)
    self.update(strava_id: "#{results["id"]}", distance: "#{results["distance"]}",
      activity_time: "#{results["moving_time"]}", avg_hr: "#{results["average_heartrate"]}",
      activity_type: "#{results["type"]}", name: "#{results["name"]}")
  end
end

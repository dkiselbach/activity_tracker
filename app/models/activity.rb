class Activity < ApplicationRecord
  belongs_to :user
  validates :strava_id, :user_id, presence: true
  validates_uniqueness_of :strava_id
  scope :exclude_laps_splits, ->  { select( Activity.attribute_names - ['laps', 'splits'] ) }

  def set_results(results)
    self.update(strava_id: "#{results["id"]}", distance: "#{results["distance"]}",
      activity_time: "#{results["moving_time"]}", avg_hr: "#{results["average_heartrate"]}",
      activity_type: "#{results["type"]}", name: "#{results["name"]}")
  end

  def set_detailed_results(detailed_results)
    self.update(calories: "#{detailed_results["calories"]}",
      laps: "#{detailed_results["laps"].to_json}", splits: "#{detailed_results["splits_standard"].to_json}"  )
  end
end

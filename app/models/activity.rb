class Activity < ApplicationRecord
  belongs_to :user
  validates :strava_id, :user_id, presence: true
  validates_uniqueness_of :strava_id
  scope :exclude_laps_splits, ->  { select( Activity.attribute_names - ['laps', 'splits'] ) }
end

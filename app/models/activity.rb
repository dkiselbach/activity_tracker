class Activity < ApplicationRecord
  belongs_to :user
  has_many :record, :foreign_key => 'strava_id', :class_name => 'Record', :primary_key => 'strava_id', :dependent => :destroy
  validates :strava_id, :user_id, presence: true
  validates_uniqueness_of :strava_id
  scope :exclude_laps_splits, ->  { select( Activity.attribute_names - ['laps', 'splits', 'splits_metric'] ) }
end

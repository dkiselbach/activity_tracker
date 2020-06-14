class Profile < ApplicationRecord
  belongs_to :user
  validates :weight, :height, :user_id, presence: true
  validates_numericality_of :weight, less_than: 500
  validates_numericality_of :height, less_than: 300
end

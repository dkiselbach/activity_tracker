class Biometric < ApplicationRecord
  belongs_to :user
  validates :weight, :user_id, presence: true
  validates_numericality_of :weight, less_than: 500
end

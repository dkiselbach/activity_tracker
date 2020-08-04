# frozen_string_literal: true

class User < ApplicationRecord
  has_one :auth, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  has_many :activity, dependent: :destroy
  has_many :biometric, dependent: :destroy
  has_many :record, dependent: :destroy
  has_many :throttle, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  accepts_nested_attributes_for :auth, allow_destroy: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png] },
                      size: { less_than: 5.megabytes }
  validates_numericality_of :weight, less_than: 500, allow_blank: true
  validates_numericality_of :height, less_than: 300, allow_blank: true
  after_save :log_weight, if: :saved_change_to_weight?

  def jwt_payload
    {
      'email' => email,
      'name' => name
    }
  end

  def log_weight
    biometric.create(weight: weight)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Activity.exclude_laps_splits.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end

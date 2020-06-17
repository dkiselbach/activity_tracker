class User < ApplicationRecord
  has_one :auth, :dependent => :destroy
  has_one_attached :image, :dependent => :purge_later
  has_many :activity, :dependent => :destroy
  has_many :biometric, :dependent => :destroy
  has_many :record, :dependent => :destroy
  has_many :throttle, :dependent => :destroy
  accepts_nested_attributes_for :auth, :allow_destroy => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png]},
                      size:         { less_than: 5.megabytes}
  validates_numericality_of :weight, less_than: 500, :allow_blank => true
  validates_numericality_of :height, less_than: 300, :allow_blank => true
  after_save :log_weight, if: :saved_change_to_weight?

    def jwt_payload
       {
         'email' => self.email,
         'name' => self.name
       }
    end

    def log_weight
      self.biometric.create(weight: self.weight)
    end
end

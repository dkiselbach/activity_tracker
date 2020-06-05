class User < ApplicationRecord
  has_one :auth, :dependent => :destroy
  has_one_attached :image, :dependent => :purge_later
  has_many :activity, :dependent => :destroy
  accepts_nested_attributes_for :auth, :allow_destroy => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png]},
                      size:         { less_than: 5.megabytes}

    def jwt_payload
       {
         'email' => self.email,
         'name' => self.name
       }
    end
end

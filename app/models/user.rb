class User < ApplicationRecord
  has_one :auth, :dependent => :destroy
  has_many :activity, :dependent => :destroy
  accepts_nested_attributes_for :auth, :allow_destroy => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

    def jwt_payload
       {
         'eml' => self.email,
         'nme' => self.name
       }
    end
end

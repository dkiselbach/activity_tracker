class User < ApplicationRecord
  has_one :auth, :dependent => :destroy
  has_many :activity
  accepts_nested_attributes_for :auth, :allow_destroy => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
end

class Auth < ApplicationRecord
  belongs_to :user
  validates :app_name, :token, :user_id, presence: true

end

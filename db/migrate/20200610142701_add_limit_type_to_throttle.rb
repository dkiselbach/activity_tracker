class AddLimitTypeToThrottle < ActiveRecord::Migration[6.0]
  def change
    add_column :throttles, :limit_type, :string
  end
end

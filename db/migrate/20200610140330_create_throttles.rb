class CreateThrottles < ActiveRecord::Migration[6.0]
  def change
    create_table :throttles do |t|
      t.integer :hourly_usage
      t.integer :daily_usage
      t.string :app_name
      t.string :limit_type
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

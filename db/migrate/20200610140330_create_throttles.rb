class CreateThrottles < ActiveRecord::Migration[6.0]
  def change
    create_table :throttles do |t|
      t.integer :hourlyusage
      t.integer :dailyusage
      t.string :appname
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

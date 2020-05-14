class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.decimal :distance
      t.datetime :time
      t.decimal :avg_hr
      t.decimal :calories
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

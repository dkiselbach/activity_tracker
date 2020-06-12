class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.string :name
      t.integer :distance
      t.integer :elapsed_time
      t.integer :moving_time
      t.datetime :start_date_local
      t.integer :pr_rank
      t.bigint :strava_id
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

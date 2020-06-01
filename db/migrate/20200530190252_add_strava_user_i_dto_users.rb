class AddStravaUserIDtoUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :strava_id, :int
    add_column :users, :strava_username, :string
    add_column :users, :strava_firstname, :string
    add_column :users, :strava_lastname, :string
    add_column :users, :strava_city, :string
    add_column :users, :strava_state, :string
    add_column :users, :strava_country, :string
    add_column :users, :strava_sex, :string
    add_column :users, :strava_created_at, :string
    add_column :users, :weight, :int
    add_column :users, :height, :int
  end
end

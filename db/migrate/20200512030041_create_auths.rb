class CreateAuths < ActiveRecord::Migration[6.0]
  def change
    create_table :auths do |t|
      t.string :app_name
      t.string :token
      t.string :refresh_token
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

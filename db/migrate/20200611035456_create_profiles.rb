class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :weight
      t.integer :height
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

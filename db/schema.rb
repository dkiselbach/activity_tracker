# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_02_033911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "distance"
    t.integer "avg_hr"
    t.integer "calories"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "strava_id"
    t.string "name"
    t.string "activity_type"
    t.integer "activity_time"
    t.jsonb "laps"
    t.jsonb "splits"
    t.datetime "start_date_local", precision: 6
    t.index ["strava_id"], name: "index_activities_on_strava_id", unique: true
  end

  create_table "auths", force: :cascade do |t|
    t.string "app_name"
    t.string "token"
    t.string "refresh_token"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_auths_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "name"
    t.integer "strava_id"
    t.string "strava_username"
    t.string "strava_firstname"
    t.string "strava_lastname"
    t.string "strava_city"
    t.string "strava_state"
    t.string "strava_country"
    t.string "strava_sex"
    t.string "strava_created_at"
    t.integer "weight"
    t.integer "height"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "users"
  add_foreign_key "auths", "users"
end

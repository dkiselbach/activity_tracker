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

ActiveRecord::Schema.define(version: 2020_08_02_195301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.float "speed"
    t.jsonb "splits_metric"
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

  create_table "biometrics", force: :cascade do |t|
    t.integer "weight"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "strava_updated", default: false
    t.index ["user_id"], name: "index_biometrics_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.string "name"
    t.integer "distance"
    t.integer "elapsed_time"
    t.integer "moving_time"
    t.datetime "start_date_local"
    t.integer "pr_rank"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "strava_id"
    t.index ["strava_id"], name: "index_records_on_strava_id"
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "throttles", force: :cascade do |t|
    t.integer "hourly_usage"
    t.integer "daily_usage"
    t.string "app_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "limit_type"
    t.index ["user_id"], name: "index_throttles_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "auths", "users"
  add_foreign_key "biometrics", "users"
  add_foreign_key "records", "users"
  add_foreign_key "throttles", "users"
end

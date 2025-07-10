# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_10_104439) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feedbacks", force: :cascade do |t|
    t.integer "rating", null: false
    t.text "comment", null: false
    t.bigint "user_id", null: false
    t.bigint "yoga_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "yoga_class_id"], name: "index_feedbacks_on_user_id_and_yoga_class_id", unique: true
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
    t.index ["yoga_class_id"], name: "index_feedbacks_on_yoga_class_id"
  end

  create_table "live_participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "yoga_class_id", null: false
    t.datetime "joined_at"
    t.datetime "left_at"
    t.integer "duration_seconds", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "yoga_class_id"], name: "index_live_participations_on_user_id_and_yoga_class_id", unique: true
    t.index ["user_id"], name: "index_live_participations_on_user_id"
    t.index ["yoga_class_id"], name: "index_live_participations_on_yoga_class_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "yoga_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "yoga_class_id"], name: "index_reservations_on_user_id_and_yoga_class_id", unique: true
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index ["yoga_class_id"], name: "index_reservations_on_yoga_class_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "yoga_classes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "start_time"
    t.string "instructor"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_live_id"
    t.integer "live_status", default: 0
  end

  add_foreign_key "feedbacks", "users"
  add_foreign_key "feedbacks", "yoga_classes"
  add_foreign_key "live_participations", "users"
  add_foreign_key "live_participations", "yoga_classes"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "yoga_classes"
end

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

ActiveRecord::Schema[7.2].define(version: 2024_10_01_120903) do
  create_table "event_user_relations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_user_relations_on_event_id"
    t.index ["user_id", "event_id", "type"], name: "index_event_user_relations_on_user_id_and_event_id_and_type", unique: true
    t.index ["user_id", "event_id"], name: "index_event_user_relations_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_user_relations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "organizer_id", null: false
    t.string "title", limit: 50, null: false
    t.string "body", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_private", default: false, null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "event_user_relations", "events"
  add_foreign_key "event_user_relations", "users"
  add_foreign_key "events", "users", column: "organizer_id"
end

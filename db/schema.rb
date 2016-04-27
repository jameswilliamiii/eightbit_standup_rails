# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160427165610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendee_standups", force: :cascade do |t|
    t.integer  "attendee_id", null: false
    t.integer  "standup_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "attendee_standups", ["attendee_id"], name: "index_attendee_standups_on_attendee_id", using: :btree
  add_index "attendee_standups", ["standup_id"], name: "index_attendee_standups_on_standup_id", using: :btree

  create_table "attendees", force: :cascade do |t|
    t.string   "hipchat_id"
    t.string   "hipchat_username"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "hipchat_mention"
  end

  add_index "attendees", ["hipchat_id"], name: "index_attendees_on_hipchat_id", using: :btree

  create_table "standups", force: :cascade do |t|
    t.datetime "end_at"
    t.datetime "remind_at",         null: false
    t.string   "hipchat_room_name", null: false
    t.integer  "user_id",           null: false
    t.string   "program_name",      null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "standups", ["program_name"], name: "index_standups_on_program_name", using: :btree
  add_index "standups", ["remind_at"], name: "index_standups_on_remind_at", using: :btree
  add_index "standups", ["user_id"], name: "index_standups_on_user_id", using: :btree

  create_table "status_updates", force: :cascade do |t|
    t.integer  "attendee_id", null: false
    t.integer  "standup_id",  null: false
    t.text     "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "status_updates", ["attendee_id"], name: "index_status_updates_on_attendee_id", using: :btree
  add_index "status_updates", ["standup_id"], name: "index_status_updates_on_standup_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

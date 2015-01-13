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

ActiveRecord::Schema.define(version: 20150112223842) do

  create_table "apify_scheduler_frequency_periods", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apify_scheduler_histories", force: true do |t|
    t.text     "response_body"
    t.integer  "apify_scheduler_unit_id"
    t.boolean  "queued",                  default: false
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apify_scheduler_servers", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apify_scheduler_servers", ["name"], name: "index_apify_scheduler_servers_on_name", unique: true

  create_table "apify_scheduler_units", force: true do |t|
    t.string   "name",                                            null: false
    t.text     "description"
    t.text     "pattern",                                         null: false
    t.integer  "delay",                               default: 0, null: false
    t.integer  "processes",                           default: 2, null: false
    t.string   "destination",                                     null: false
    t.integer  "apify_scheduler_server_id"
    t.integer  "frequency_quantity"
    t.integer  "apify_scheduler_frequency_period_id"
    t.string   "at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apify_scheduler_units", ["apify_scheduler_frequency_period_id"], name: "frequency_id"
  add_index "apify_scheduler_units", ["apify_scheduler_server_id"], name: "index_apify_scheduler_units_on_apify_scheduler_server_id"
  add_index "apify_scheduler_units", ["name"], name: "index_apify_scheduler_units_on_name", unique: true

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

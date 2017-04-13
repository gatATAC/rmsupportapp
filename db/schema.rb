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

ActiveRecord::Schema.define(version: 20170413170104) do

  create_table "redmine_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_groups", ["redmine_server_id"], name: "index_redmine_groups_on_redmine_server_id"

  create_table "redmine_issue_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_issue_statuses", ["redmine_server_id"], name: "index_redmine_issue_statuses_on_redmine_server_id"

  create_table "redmine_projects", force: :cascade do |t|
    t.string   "identifier"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_projects", ["redmine_server_id"], name: "index_redmine_projects_on_redmine_server_id"

  create_table "redmine_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_roles", ["redmine_server_id"], name: "index_redmine_roles_on_redmine_server_id"

  create_table "redmine_servers", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "admin_api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redmine_trackers", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_trackers", ["redmine_server_id"], name: "index_redmine_trackers_on_redmine_server_id"

  create_table "redmine_users", force: :cascade do |t|
    t.string   "login"
    t.string   "apikey"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
    t.integer  "rmid"
  end

  add_index "redmine_users", ["redmine_server_id"], name: "index_redmine_users_on_redmine_server_id"

  create_table "users", force: :cascade do |t|
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                default: "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], name: "index_users_on_state"

end

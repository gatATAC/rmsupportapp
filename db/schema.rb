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

ActiveRecord::Schema.define(version: 20170414151933) do

  create_table "redmine_custom_fields", force: :cascade do |t|
    t.integer  "rmid"
    t.string   "name"
    t.string   "customized_type"
    t.string   "field_format"
    t.string   "regexp"
    t.integer  "min_length"
    t.integer  "max_length"
    t.boolean  "is_required"
    t.boolean  "is_filter"
    t.boolean  "searchable"
    t.boolean  "multiple"
    t.string   "default_value"
    t.boolean  "is_visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_custom_fields", ["redmine_server_id"], name: "index_redmine_custom_fields_on_redmine_server_id"

  create_table "redmine_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_groups", ["redmine_server_id"], name: "index_redmine_groups_on_redmine_server_id"

  create_table "redmine_issue_custom_fields", force: :cascade do |t|
    t.string   "cfield_name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_issue_id"
    t.integer  "redmine_custom_field_id"
  end

  add_index "redmine_issue_custom_fields", ["redmine_custom_field_id"], name: "index_redmine_issue_custom_fields_on_redmine_custom_field_id"
  add_index "redmine_issue_custom_fields", ["redmine_issue_id"], name: "index_redmine_issue_custom_fields_on_redmine_issue_id"

  create_table "redmine_issue_priorities", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_issue_priorities", ["redmine_server_id"], name: "index_redmine_issue_priorities_on_redmine_server_id"

  create_table "redmine_issue_relations", force: :cascade do |t|
    t.string   "relation_type"
    t.integer  "delay"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_issue_id"
    t.integer  "destination_issue_id"
  end

  add_index "redmine_issue_relations", ["destination_issue_id"], name: "index_redmine_issue_relations_on_destination_issue_id"
  add_index "redmine_issue_relations", ["redmine_issue_id"], name: "index_redmine_issue_relations_on_redmine_issue_id"

  create_table "redmine_issue_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
  end

  add_index "redmine_issue_statuses", ["redmine_server_id"], name: "index_redmine_issue_statuses_on_redmine_server_id"

  create_table "redmine_issues", force: :cascade do |t|
    t.string   "subject"
    t.integer  "rmid"
    t.text     "description"
    t.date     "start_date"
    t.date     "due_date"
    t.integer  "done_ratio"
    t.float    "estimated_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_project_id"
    t.integer  "redmine_user_id"
    t.integer  "redmine_group_id"
    t.integer  "author_id"
    t.integer  "redmine_tracker_id"
    t.integer  "redmine_issue_status_id"
    t.integer  "redmine_issue_priority_id"
    t.integer  "redmine_version_id"
    t.boolean  "is_private"
    t.integer  "parent_id"
    t.integer  "parent_rmid"
  end

  add_index "redmine_issues", ["author_id"], name: "index_redmine_issues_on_author_id"
  add_index "redmine_issues", ["parent_id"], name: "index_redmine_issues_on_parent_id"
  add_index "redmine_issues", ["redmine_group_id"], name: "index_redmine_issues_on_redmine_group_id"
  add_index "redmine_issues", ["redmine_issue_priority_id"], name: "index_redmine_issues_on_redmine_issue_priority_id"
  add_index "redmine_issues", ["redmine_issue_status_id"], name: "index_redmine_issues_on_redmine_issue_status_id"
  add_index "redmine_issues", ["redmine_project_id"], name: "index_redmine_issues_on_redmine_project_id"
  add_index "redmine_issues", ["redmine_tracker_id"], name: "index_redmine_issues_on_redmine_tracker_id"
  add_index "redmine_issues", ["redmine_user_id"], name: "index_redmine_issues_on_redmine_user_id"
  add_index "redmine_issues", ["redmine_version_id"], name: "index_redmine_issues_on_redmine_version_id"

  create_table "redmine_membership_roles", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_membership_id"
    t.integer  "redmine_role_id"
  end

  add_index "redmine_membership_roles", ["redmine_membership_id"], name: "index_redmine_membership_roles_on_redmine_membership_id"
  add_index "redmine_membership_roles", ["redmine_role_id"], name: "index_redmine_membership_roles_on_redmine_role_id"

  create_table "redmine_memberships", force: :cascade do |t|
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_project_id"
    t.integer  "redmine_user_id"
    t.integer  "redmine_group_id"
  end

  add_index "redmine_memberships", ["redmine_group_id"], name: "index_redmine_memberships_on_redmine_group_id"
  add_index "redmine_memberships", ["redmine_project_id"], name: "index_redmine_memberships_on_redmine_project_id"
  add_index "redmine_memberships", ["redmine_user_id"], name: "index_redmine_memberships_on_redmine_user_id"

  create_table "redmine_projects", force: :cascade do |t|
    t.string   "identifier"
    t.integer  "rmid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_server_id"
    t.string   "name"
    t.text     "description"
    t.string   "homepage"
    t.integer  "status"
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

  create_table "redmine_versions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.date     "due_date"
    t.string   "sharing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_project_id"
    t.integer  "rmid"
  end

  add_index "redmine_versions", ["redmine_project_id"], name: "index_redmine_versions_on_redmine_project_id"

  create_table "redmine_wikis", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "title"
    t.integer  "rmid"
    t.text     "wikitext"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redmine_project_id"
    t.integer  "redmine_user_id"
    t.string   "parent_title"
  end

  add_index "redmine_wikis", ["parent_id"], name: "index_redmine_wikis_on_parent_id"
  add_index "redmine_wikis", ["redmine_project_id"], name: "index_redmine_wikis_on_redmine_project_id"
  add_index "redmine_wikis", ["redmine_user_id"], name: "index_redmine_wikis_on_redmine_user_id"

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

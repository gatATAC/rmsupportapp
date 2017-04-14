class AddRedmineIssues < ActiveRecord::Migration
  def self.up
    create_table :redmine_issues do |t|
      t.string   :subject
      t.integer  :rmid
      t.text     :description
      t.date     :start_date
      t.date     :due_date
      t.integer  :done_ratio
      t.float    :estimated_hours
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
      t.integer  :redmine_user_id
      t.integer  :redmine_group_id
      t.integer  :author_id
      t.integer  :redmine_tracker_id
      t.integer  :redmine_issue_status_id
      t.integer  :redmine_issue_priority_id
      t.integer  :redmine_version_id
    end
    add_index :redmine_issues, [:redmine_project_id]
    add_index :redmine_issues, [:redmine_user_id]
    add_index :redmine_issues, [:redmine_group_id]
    add_index :redmine_issues, [:author_id]
    add_index :redmine_issues, [:redmine_tracker_id]
    add_index :redmine_issues, [:redmine_issue_status_id]
    add_index :redmine_issues, [:redmine_issue_priority_id]
    add_index :redmine_issues, [:redmine_version_id]
  end

  def self.down
    drop_table :redmine_issues
  end
end

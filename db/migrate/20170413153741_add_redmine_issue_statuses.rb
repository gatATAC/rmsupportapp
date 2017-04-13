class AddRedmineIssueStatuses < ActiveRecord::Migration
  def self.up
    create_table :redmine_issue_statuses do |t|
      t.string   :name
      t.integer  :rmid
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_server_id
    end
    add_index :redmine_issue_statuses, [:redmine_server_id]
  end

  def self.down
    drop_table :redmine_issue_statuses
  end
end

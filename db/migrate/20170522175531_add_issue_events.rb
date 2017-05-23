class AddIssueEvents < ActiveRecord::Migration
  def self.up
    create_table :redmine_issue_event_links do |t|
      t.boolean  :input_type
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_issue_id
      t.integer  :redmine_issue_event_id
    end
    add_index :redmine_issue_event_links, [:redmine_issue_id]
    add_index :redmine_issue_event_links, [:redmine_issue_event_id]

    create_table :redmine_issue_events do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
    end
    add_index :redmine_issue_events, [:redmine_project_id]
  end

  def self.down
    drop_table :redmine_issue_event_links
    drop_table :redmine_issue_events
  end
end

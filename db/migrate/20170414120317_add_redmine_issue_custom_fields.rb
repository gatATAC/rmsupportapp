class AddRedmineIssueCustomFields < ActiveRecord::Migration
  def self.up
    create_table :redmine_issue_custom_fields do |t|
      t.integer  :rmid
      t.string   :name
      t.string   :value
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_issue_id
      t.integer  :redmine_custom_field_id
    end
    add_index :redmine_issue_custom_fields, [:redmine_issue_id]
    add_index :redmine_issue_custom_fields, [:redmine_custom_field_id]
  end

  def self.down
    drop_table :redmine_issue_custom_fields
  end
end

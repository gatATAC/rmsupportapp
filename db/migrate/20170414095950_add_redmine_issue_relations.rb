class AddRedmineIssueRelations < ActiveRecord::Migration
  def self.up
    create_table :redmine_issue_relations do |t|
      t.string   :relation_type
      t.integer  :delay
      t.integer  :rmid      
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_issue_id
      t.integer  :destination_issue_id
    end
    add_index :redmine_issue_relations, [:redmine_issue_id]
    add_index :redmine_issue_relations, [:destination_issue_id]
  end

  def self.down
    drop_table :redmine_issue_relations
  end
end

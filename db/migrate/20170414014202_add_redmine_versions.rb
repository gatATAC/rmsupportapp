class AddRedmineVersions < ActiveRecord::Migration
  def self.up
    create_table :redmine_versions do |t|
      t.string   :name
      t.text     :description
      t.string   :status
      t.date     :due_date
      t.string   :sharing
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
    end
    add_index :redmine_versions, [:redmine_project_id]
  end

  def self.down
    drop_table :redmine_versions
  end
end

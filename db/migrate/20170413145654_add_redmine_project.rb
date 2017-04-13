class AddRedmineProject < ActiveRecord::Migration
  def self.up
    create_table :redmine_projects do |t|
      t.string   :identifier
      t.integer  :rmid
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_server_id
    end
    add_index :redmine_projects, [:redmine_server_id]
  end

  def self.down
    drop_table :redmine_projects
  end
end

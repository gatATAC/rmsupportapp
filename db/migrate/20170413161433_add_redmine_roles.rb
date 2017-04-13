class AddRedmineRoles < ActiveRecord::Migration
  def self.up
    create_table :redmine_roles do |t|
      t.string   :name
      t.integer  :rmid
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_server_id
    end
    add_index :redmine_roles, [:redmine_server_id]
  end

  def self.down
    drop_table :redmine_roles
  end
end

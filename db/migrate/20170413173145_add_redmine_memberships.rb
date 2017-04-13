class AddRedmineMemberships < ActiveRecord::Migration
  def self.up
    create_table :redmine_memberships do |t|
      t.integer  :rmid
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
      t.integer  :redmine_user_id
    end
    add_index :redmine_memberships, [:redmine_project_id]
    add_index :redmine_memberships, [:redmine_user_id]
  end

  def self.down
    drop_table :redmine_memberships
  end
end

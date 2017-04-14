class AddMembershipRoles < ActiveRecord::Migration
  def self.up
    create_table :redmine_membership_roles do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_membership_id
      t.integer  :redmine_role_id
    end
    add_index :redmine_membership_roles, [:redmine_membership_id]
    add_index :redmine_membership_roles, [:redmine_role_id]
  end

  def self.down
    drop_table :redmine_membership_roles
  end
end

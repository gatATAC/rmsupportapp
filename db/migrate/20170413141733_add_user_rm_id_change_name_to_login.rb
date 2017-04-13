class AddUserRmIdChangeNameToLogin < ActiveRecord::Migration
  def self.up
    rename_column :redmine_users, :name, :login
    add_column :redmine_users, :rm_id, :integer
  end

  def self.down
    rename_column :redmine_users, :login, :name
    remove_column :redmine_users, :rm_id
  end
end

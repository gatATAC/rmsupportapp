class RenameRmIdToRmid < ActiveRecord::Migration
  def self.up
    change_column :users, :administrator, :boolean, :default => false

    rename_column :redmine_users, :rm_id, :rmid
  end

  def self.down
    change_column :users, :administrator, :boolean, default: false

    rename_column :redmine_users, :rmid, :rm_id
  end
end

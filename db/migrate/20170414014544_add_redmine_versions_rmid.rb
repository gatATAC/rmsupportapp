class AddRedmineVersionsRmid < ActiveRecord::Migration
  def self.up
    add_column :redmine_versions, :rmid, :integer
  end

  def self.down
    remove_column :redmine_versions, :rmid
  end
end

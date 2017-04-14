class AddIssuePrivate < ActiveRecord::Migration
  def self.up
    add_column :redmine_issues, :is_private, :boolean
  end

  def self.down
    remove_column :redmine_issues, :is_private
  end
end

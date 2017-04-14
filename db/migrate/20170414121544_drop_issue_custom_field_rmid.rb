class DropIssueCustomFieldRmid < ActiveRecord::Migration
  def self.up
    remove_column :redmine_issue_custom_fields, :rmid
  end

  def self.down
    add_column :redmine_issue_custom_fields, :rmid, :integer
  end
end

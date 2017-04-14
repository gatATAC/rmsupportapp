class RenameIssueCustomFieldNameAttribute < ActiveRecord::Migration
  def self.up
    rename_column :redmine_issue_custom_fields, :name, :cfield_name
  end

  def self.down
    rename_column :redmine_issue_custom_fields, :cfield_name, :name
  end
end

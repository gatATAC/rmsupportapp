class AddMicMatToEvents < ActiveRecord::Migration
  def self.up
    add_column :redmine_issue_events, :MIC, :float
    add_column :redmine_issue_events, :MAC, :float
  end

  def self.down
    remove_column :redmine_issue_events, :MIC
    remove_column :redmine_issue_events, :MAC
  end
end

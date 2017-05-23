class AddIssueMetricsColumns < ActiveRecord::Migration
  def self.up
    add_column :redmine_issues, :MIC, :float
    add_column :redmine_issues, :MAC, :float
    add_column :redmine_issues, :MIT, :float
    add_column :redmine_issues, :MAT, :float
    add_column :redmine_issues, :Hl, :float
    add_column :redmine_issues, :Ht, :float
    add_column :redmine_issues, :Hi, :float
    add_column :redmine_issues, :initial_action, :boolean
    add_column :redmine_issues, :final_action, :boolean
  end

  def self.down
    remove_column :redmine_issues, :MIC
    remove_column :redmine_issues, :MAC
    remove_column :redmine_issues, :MIT
    remove_column :redmine_issues, :MAT
    remove_column :redmine_issues, :Hl
    remove_column :redmine_issues, :Ht
    remove_column :redmine_issues, :Hi
    remove_column :redmine_issues, :initial_action
    remove_column :redmine_issues, :final_action
  end
end

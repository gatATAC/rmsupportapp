class AddIssueHelp < ActiveRecord::Migration
  def self.up
    add_column :redmine_servers, :help_server_url, :string, :default => nil
    add_column :redmine_servers, :help_project, :string, :default => "help"
  end

  def self.down
    remove_column :redmine_servers, :help_server_url
    remove_column :redmine_servers, :help_project
  end
end

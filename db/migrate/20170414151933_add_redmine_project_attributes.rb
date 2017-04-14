class AddRedmineProjectAttributes < ActiveRecord::Migration
  def self.up
    add_column :redmine_projects, :name, :string
    add_column :redmine_projects, :description, :text
    add_column :redmine_projects, :homepage, :string
    add_column :redmine_projects, :status, :integer
  end

  def self.down
    remove_column :redmine_projects, :name
    remove_column :redmine_projects, :description
    remove_column :redmine_projects, :homepage
    remove_column :redmine_projects, :status
  end
end

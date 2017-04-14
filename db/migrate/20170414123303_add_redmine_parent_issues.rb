class AddRedmineParentIssues < ActiveRecord::Migration
  def self.up
    add_column :redmine_issues, :parent_id, :integer
    add_column :redmine_issues, :parent_rmid, :integer

    add_index :redmine_issues, [:parent_id]
  end

  def self.down
    remove_column :redmine_issues, :parent_id
    remove_column :redmine_issues, :parent_rmid

    remove_index :redmine_issues, :name => :index_redmine_issues_on_parent_id rescue ActiveRecord::StatementInvalid
  end
end

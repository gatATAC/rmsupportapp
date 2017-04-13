class AddRedmineGroupMemberships < ActiveRecord::Migration
  def self.up
    add_column :redmine_memberships, :redmine_group_id, :integer

    add_index :redmine_memberships, [:redmine_group_id]
  end

  def self.down
    remove_column :redmine_memberships, :redmine_group_id

    remove_index :redmine_memberships, :name => :index_redmine_memberships_on_redmine_group_id rescue ActiveRecord::StatementInvalid
  end
end

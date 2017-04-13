class AddRmUserRelation < ActiveRecord::Migration
  def self.up
    add_column :redmine_users, :redmine_server_id, :integer

    add_index :redmine_users, [:redmine_server_id]
  end

  def self.down
    remove_column :redmine_users, :redmine_server_id

    remove_index :redmine_users, :name => :index_redmine_users_on_redmine_server_id rescue ActiveRecord::StatementInvalid
  end
end

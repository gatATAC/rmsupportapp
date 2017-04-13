class AddRmServers < ActiveRecord::Migration
  def self.up
    create_table :redmine_servers do |t|
      t.string   :name
      t.string   :url
      t.string   :admin_api_key
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :redmine_servers
  end
end

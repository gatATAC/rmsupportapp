class AddRedmineTrackers < ActiveRecord::Migration
  def self.up
    create_table :redmine_trackers do |t|
      t.string   :name
      t.integer  :rmid
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_server_id
    end
    add_index :redmine_trackers, [:redmine_server_id]
  end

  def self.down
    drop_table :redmine_trackers
  end
end

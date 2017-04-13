class AddRmUsers < ActiveRecord::Migration
  def self.up
    create_table :redmine_users do |t|
      t.string   :name
      t.string   :apikey
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :redmine_users
  end
end

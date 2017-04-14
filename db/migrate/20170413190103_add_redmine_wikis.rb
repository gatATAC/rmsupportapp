class AddRedmineWikis < ActiveRecord::Migration
  def self.up
    create_table :redmine_wikis do |t|
      t.integer  :parent_id
      t.string   :title
      t.integer  :rmid
      t.text     :wikitext
      t.integer  :version
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
      t.integer  :redmine_user_id
    end
    add_index :redmine_wikis, [:parent_id]
    add_index :redmine_wikis, [:redmine_project_id]
    add_index :redmine_wikis, [:redmine_user_id]
  end

  def self.down
    drop_table :redmine_wikis
  end
end

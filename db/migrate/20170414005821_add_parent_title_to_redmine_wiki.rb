class AddParentTitleToRedmineWiki < ActiveRecord::Migration
  def self.up
    add_column :redmine_wikis, :parent_title, :string
  end

  def self.down
    remove_column :redmine_wikis, :parent_title
  end
end

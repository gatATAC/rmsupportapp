class AddProjectCustomFields < ActiveRecord::Migration
  def self.up
    create_table :redmine_project_custom_fields do |t|
      t.string   :cfield_name
      t.string   :value
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_project_id
      t.integer  :redmine_custom_field_id
    end
    add_index :redmine_project_custom_fields, [:redmine_project_id]
    add_index :redmine_project_custom_fields, [:redmine_custom_field_id]
  end

  def self.down
    drop_table :redmine_project_custom_fields
  end
end

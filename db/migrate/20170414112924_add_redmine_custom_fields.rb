class AddRedmineCustomFields < ActiveRecord::Migration
  def self.up
    create_table :redmine_custom_fields do |t|
      t.integer  :rmid
      t.string   :name
      t.string   :customized_type
      t.string   :field_format
      t.string   :regexp
      t.integer  :min_length
      t.integer  :max_length
      t.boolean  :is_required
      t.boolean  :is_filter
      t.boolean  :searchable
      t.boolean  :multiple
      t.string   :default_value
      t.boolean  :is_visible
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :redmine_server_id
    end
    add_index :redmine_custom_fields, [:redmine_server_id]
  end

  def self.down
    drop_table :redmine_custom_fields
  end
end

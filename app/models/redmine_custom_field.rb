class RedmineCustomField < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    rmid            :integer
    name            :string
    customized_type :string
    field_format    :string
    regexp          :string
    min_length      :integer
    max_length      :integer
    is_required     :boolean
    is_filter       :boolean
    searchable      :boolean
    multiple        :boolean
    default_value   :string
    is_visible      :boolean
    timestamps
  end
  attr_accessible :rmid, :name, :customized_type, :field_format, :regexp, :min_length, :max_length, :is_required, :is_filter, :searchable, :multiple, :default_value, :is_visible

  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_custom_fields  
  
  has_many :redmine_issue_custom_fields, :dependent => :destroy, :inverse_of => :redmine_custom_field
  has_many :redmine_project_custom_fields, :dependent => :destroy, :inverse_of => :redmine_custom_field
  
  children :redmine_issue_custom_fields, :redmine_project_custom_fields
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

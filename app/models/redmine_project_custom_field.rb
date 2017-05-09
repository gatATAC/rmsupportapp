class RedmineProjectCustomField < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    cfield_name :string
    value       :string
    timestamps
  end
  attr_accessible :cfield_name, :value
  
  belongs_to :redmine_project, :inverse_of => :redmine_project_custom_fields, :creator => :true
  belongs_to :redmine_custom_field, :inverse_of => :redmine_project_custom_fields
  
  def name
    if (value) then
        cfield_name+": "+value
    else
        cfield_name+": (nil)"
    end
  end
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

class RedmineProject < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    identifier :string
    rmid :integer    
    timestamps
  end
  attr_accessible :identifier, :rmid
  
  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_projects

  def name
    identifier
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

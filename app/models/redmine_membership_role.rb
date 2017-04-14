class RedmineMembershipRole < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  
  attr_accessible 

  belongs_to :redmine_membership, :creator => :true, :inverse_of => :redmine_membership_roles
  belongs_to :redmine_role, :inverse_of => :redmine_membership_roles
  
  
  def name
    redmine_role.name
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

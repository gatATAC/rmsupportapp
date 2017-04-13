class RedmineMembership < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    rmid :integer
    timestamps
  end
  attr_accessible :rmid, :redmine_user_id, :redmine_group_id, :redmine_user, :redmine_group

  belongs_to :redmine_project, :creator => :true, :inverse_of => :redmine_memberships
  belongs_to :redmine_user, :inverse_of => :redmine_memberships
  belongs_to :redmine_group, :inverse_of => :redmine_memberships
  
  def name
    if (self.redmine_user) then
      "User: "+redmine_user.name
    else
      if (self.redmine_group) then
        "Group: "+redmine_group.name
      else
        "ERROR"
      end
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

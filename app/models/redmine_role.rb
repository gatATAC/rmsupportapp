class RedmineRole < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    rmid :integer
    timestamps
  end
  attr_accessible :name, :rmid

  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_roles
  
  has_many :redmine_membership_roles, :inverse_of => :redmine_role, :dependent => :destroy
  has_many :redmine_memberships, :through => :redmine_membership_roles, :inverse_of => :redmine_roles

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

class RedmineTracker < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    rmid :integer
    timestamps
  end
  attr_accessible :name, :rmid
  
  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_trackers
  has_many :redmine_issues, :inverse_of => :redmine_tracker

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

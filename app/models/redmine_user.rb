class RedmineUser < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name   :string
    apikey :string
    timestamps
  end
  attr_accessible :name, :apikey
  
  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_users

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

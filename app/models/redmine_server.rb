class RedmineServer < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    url  :string
    admin_api_key :string
    timestamps
  end
  attr_accessible :name, :url, :admin_api_key

  has_many :redmine_users, :dependent => :destroy, :inverse_of => :redmine_server
  
  children :redmine_users
  
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

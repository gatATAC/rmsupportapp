class RedmineUser < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    login   :string
    apikey :string
    rmid :integer
    timestamps
  end
  attr_accessible :login, :apikey, :rmid
  
  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_users

  has_many :redmine_memberships, :dependent => :destroy, :inverse_of => :redmine_user
  has_many :redmine_wikis, :dependent => :destroy, :inverse_of => :redmine_user
  has_many :redmine_issues, :inverse_of => :redmine_user
  has_many :redmine_created_issues, :class_name => 'Issue', :inverse_of => :author
  
  def name
    login
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

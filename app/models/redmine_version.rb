class RedmineVersion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    rmid     :integer
    name        :string
    description :text
    status      :string
    due_date    :date
    sharing     :string
    timestamps
  end
  attr_accessible :rmid, :name, :description, :status, :due_date, :sharing

  belongs_to :redmine_project, :creator => :true, :inverse_of => :redmine_versions
  has_many :redmine_issues, :inverse_of => :redmine_version

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

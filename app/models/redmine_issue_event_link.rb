class RedmineIssueEventLink < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    input_type :boolean
    timestamps
  end
  attr_accessible 

  belongs_to :redmine_issue, :inverse_of => :redmine_issue_event_links, :creator => :true
  belongs_to :redmine_issue_event, :inverse_of => :redmine_issue_event_links

  def name
    ret = redmine_issue_event.name
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

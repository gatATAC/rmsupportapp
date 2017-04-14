class RedmineIssue < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    subject         :string
    rmid            :integer
    description     :text
    start_date      :date
    due_date        :date
    done_ratio      :integer
    estimated_hours :float
    is_private      :boolean
    timestamps
  end
  attr_accessible :subject, :rmid, :description, :start_date, :due_date, :done_ratio, :estimated_hours
  belongs_to :redmine_project, :creator => :true, :inverse_of => :redmine_issues
  belongs_to :redmine_user, :inverse_of => :redmine_issues
  belongs_to :redmine_group, :inverse_of => :redmine_issues
  belongs_to :author, :inverse_of => :redmine_created_issues, :class_name => "RedmineUser"
  belongs_to :redmine_tracker, :inverse_of => :redmine_issues
  belongs_to :redmine_issue_status, :inverse_of => :redmine_issues
  belongs_to :redmine_issue_priority, :inverse_of => :redmine_issues
  belongs_to :redmine_version, :inverse_of => :redmine_issues

  def name
    subject
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

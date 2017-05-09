class RedmineIssue < ActiveRecord::Base
  hobo_model # Don't put anything above this

  acts_as_tree  

  fields do
    subject         :string
    rmid            :integer
    description     :text
    start_date      :date
    due_date        :date
    done_ratio      :integer
    estimated_hours :float
    is_private      :boolean
    parent_rmid     :integer
    timestamps
  end
  attr_accessible :subject, :rmid, :description, :start_date, :due_date, 
    :done_ratio, :estimated_hours, :parent_rmid
  belongs_to :redmine_project, :creator => :true, :inverse_of => :redmine_issues
  belongs_to :redmine_user, :inverse_of => :redmine_issues
  belongs_to :redmine_group, :inverse_of => :redmine_issues
  belongs_to :author, :inverse_of => :redmine_created_issues, :class_name => "RedmineUser"
  belongs_to :redmine_tracker, :inverse_of => :redmine_issues
  belongs_to :redmine_issue_status, :inverse_of => :redmine_issues
  belongs_to :redmine_issue_priority, :inverse_of => :redmine_issues
  belongs_to :redmine_version, :inverse_of => :redmine_issues

  has_many :redmine_issue_relations, :dependent => :destroy, :inverse_of => :redmine_issue
  has_many :relation_sources, :dependent => :destroy, :inverse_of => :destination_issue, :class_name => 'RedmineIssueRelation'
  has_many :relation_source_issues, :through => :relation_sources, :class_name => 'RedmineIssue',
    :inverse_of => :relation_destination_issues
  has_many :relation_destination_issues, :through => :relation_sources, :class_name => 'RedmineIssue',
    :inverse_of => :relation_source_issues

  has_many :redmine_issue_custom_fields, :dependent => :destroy, :inverse_of => :redmine_issue
  has_one :redmine_server, :through => :redmine_project, :inverse_of => :redmine_issues
  
  children :redmine_issue_custom_fields, :redmine_issue_relations
  
  def name
    if self.parent then
      ret = "#"+self.parent.rmid.to_s+":"
    else
      ret = ""
    end
    ret += "#"+self.rmid.to_s+": "+self.subject
  end

  def reload_all
  
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

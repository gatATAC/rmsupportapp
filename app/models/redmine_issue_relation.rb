class RedmineIssueRelation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    relation_type :string
    delay :integer
    rmid :integer
    timestamps
  end
  attr_accessible :relation_type, :delay, :rmid

  belongs_to :redmine_issue, :inverse_of => :redmine_issue_relations, :creator => :true
  belongs_to :destination_issue, :inverse_of => :relation_sources, :class_name => "RedmineIssue"
  
  def name
    ret = "#"+self.redmine_issue.rmid.to_s+" "+self.relation_type
    if (self.delay) then
      ret = ret + "["+self.delay.to_s+"]"
    end
    ret = ret + " #"+self.destination_issue.rmid.to_s
    
    return ret
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

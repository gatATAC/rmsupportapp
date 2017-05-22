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
  has_many :relation_sources, :dependent => :destroy, :inverse_of => :destination_issue, :class_name => 'RedmineIssueRelation', :foreign_key => :destination_issue_id
  has_many :relation_destinations, :dependent => :destroy, :inverse_of => :redmine_issue, :class_name => 'RedmineIssueRelation', :foreign_key => :redmine_issue_id
  has_many :relation_source_issues, :through => :relation_sources, :class_name => 'RedmineIssue',
    :inverse_of => :relation_destination_issues
  has_many :relation_destination_issues, :through => :relation_destinations, :class_name => 'RedmineIssue',
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
  
  def precessor_relations_issue_subjects
    ret = []
    self.precessor_relations.each { |i|
      ret << i.redmine_issue.subject
    }
    return ret
  end
  
  def precessor_relations
    ret = []
    self.relation_sources.each { |r|
      if r.relation_type == "precedes" then
        ret << r
      end
    }
    return ret
  end  
  
  def successor_relations
    ret = []
    self.relation_destinations.each { |r|
      if r.relation_type == "precedes" then
        ret << r
      end
    }
    return ret
  end
  
  def initial_action?
    self.precessor_relations.size == 0
  end

  def final_action?
    self.successor_relations.size == 0
  end
  
  def duration
    if (self.estimated_hours) then
      ret = self.estimated_hours / 8.0
    else
      ret = 0.0
    end
  end
  
  def MIC
    mics = [0.0]
    self.precessor_relations.each{ |r|
      mics << r.redmine_issue.MIC + r.redmine_issue.duration
    }
    return mics.max
  end
  
  def MAC
    self.MAT - self.duration
  end
  
  def MIT
    self.MIC + self.duration
  end
  
  def MAT
    if self.successor_relations.empty? then
      ret = self.MIT
    else
      mats = [0.0]
      self.successor_relations.each{ |r|
        mats << r.destination_issue.MAT - r.destination_issue.duration
      }
      ret = mats.max
    end
    return ret
  end
  
  def Hl
    # Hl = MIC del suceso posterior - MIC del suceso anterior - duración tarea
    # MIC DE TAREA (“early” de tarea) = MIC de suceso anterior
    if self.successor_relations.empty? then
      ret = self.MIT
    else
      tmp = [0.0]
      self.successor_relations.each { |r|
        tmp << r.destination_issue.MIC
      }
      ret = tmp.max
    end
    ret = ret - self.MIC - self.duration
    
    return ret
  end
  

  def Ht
    #   Ht = MAC del suceso posterior - MIC del suceso anterior - duración tarea
    # MIC DE TAREA (“early” de tarea) = MIC de suceso anterior
    # MAT DE TAREA (“last” de tarea) = MAC de suceso posterior
    ret = self.MAT - self.MIC - self.duration

    return ret
  end
  
  def Hi
    # Hi = MIC del suceso posterior - MAC del suceso anterior -duración tarea
    # MAC DE TAREA = MAC de suceso posterior - duración de tarea
    if self.successor_relations.empty? then
      ret = self.MIT
    else
      tmp = [0.0]
      self.successor_relations.each { |r|
        tmp << r.destination_issue.MIC
      }
      ret = tmp.max
    end
    
    if self.precessor_relations.empty? then
      ret2 = self.MIC
    else    
      self.precessor_relations.each { |r|
        ret2 = r.redmine_issue.MAT
      }
    end
    ret = ret - ret2 - self.duration
    
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

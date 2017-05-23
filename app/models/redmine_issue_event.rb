class RedmineIssueEvent < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    MIC :float
    MAC :float
    timestamps
  end
  attr_accessible :name, :redmine_issue_event_links

  belongs_to :redmine_project, :inverse_of => :redmine_issue_events

  has_many :redmine_issue_event_links, :dependent => :destroy, :inverse_of => :redmine_issue_event
  has_many :link_sources, -> { where input_type: true }, :dependent => :destroy, :inverse_of => :redmine_issue_event, :class_name => 'RedmineIssueEventLink'
  has_many :link_destinations, -> { where input_type: false }, :dependent => :destroy, :inverse_of => :redmine_issue_event, :class_name => 'RedmineIssueEventLink'
  has_many :input_issues, :through => :link_sources, :class_name => 'RedmineIssue',
    :inverse_of => :output_events, :source => :redmine_issue
  has_many :output_issues, :through => :link_destinations, :class_name => 'RedmineIssue',
    :inverse_of => :input_events, :source => :redmine_issue

  children :input_issues, :output_issues

  def calculate_MIC
    prev_mics =  [0.0]
    self.input_issues.each {|ii|
      self.redmine_project.redmine_issue_events.each{ |e| 
        if (e != self) then
          if (e.output_issues.include?(ii)) then
            e.calculate_MIC
            prev_mics << e.MIC + ii.duration
          end
        end
      }
    }
    self.MIC = prev_mics.max
    self.save
  end

  def calculate_MAC
    if (self.output_issues.empty?) then
      self.MAC = self.MIC
    else
      post_macs =  [111111111111111111111111.0]

      self.output_issues.each {|oi|
        self.redmine_project.redmine_issue_events.each{ |e| 
          if (e != self) then
            if (e.input_issues.include?(oi)) then
              e.calculate_MAC
              post_macs << e.MAC - oi.duration
            end
          end
        }
      }
      self.MAC = post_macs.min
    end
    self.save
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

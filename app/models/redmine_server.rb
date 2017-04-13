class RedmineServer < ActiveRecord::Base
  include RedmineRest::Models
  
  hobo_model # Don't put anything above this

  fields do
    name :string
    url  :string
    admin_api_key :string
    timestamps
  end
  attr_accessible :name, :url, :admin_api_key

  has_many :redmine_users, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_projects, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_trackers, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_issue_statuses, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_roles, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_groups, :dependent => :destroy, :inverse_of => :redmine_server
  
  children :redmine_users, :redmine_projects, :redmine_trackers, :redmine_issue_statuses, 
    :redmine_roles, :redmine_groups
  
  def reload_users
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    pending_users = true
    pending_offset = 0
    extra = []
    extra += self.redmine_users
    while (pending_users) do
      users = RedmineRest::Models::User.where(offset:pending_offset, order:('id desc'))
      if (users != nil) then
        print("\n\n\n\n\n\n\n\n\ntengo users = "+users.size.to_s)
        pending_offset += users.size
        if (users.size > 0) then
          print("\ntengo users = "+users.size.to_s)
          users.each do |user|
            print("\ntrato el user "+user.id.to_s)
            rm_user = self.redmine_users.find_by_rmid(user.id)
            if (not(rm_user)) then
              rm_user = RedmineUser.new
              rm_user.rmid = user.id
              rm_user.redmine_server = self
            else
              extra.delete(rm_user)
            end
            rm_user.login = user.login
            #rm_user.apikey = user.api_key
            rm_user.save
          end
        else
          pending_users = false
        end
      else
        pending_users = false
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end
  
  def reload_projects
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    pending_projects = true
    pending_offset = 0
    extra = []
    extra += self.redmine_projects
    while (pending_projects) do
      projects = RedmineRest::Models::Project.where(offset:pending_offset, order:('id desc'))
      if (projects != nil) then
        print("\n\n\n\n\n\n\n\n\ntengo projects = "+projects.size.to_s)
        pending_offset += projects.size
        if (projects.size > 0) then
          print("\ntengo projects = "+projects.size.to_s)
          projects.each do |project|
            print("\ntrato el project "+project.id.to_s)
            rm_project = self.redmine_projects.find_by_rmid(project.id)
            if (not(rm_project)) then
              rm_project = RedmineProject.new
              rm_project.rmid = project.id
              rm_project.redmine_server = self
            else
              extra.delete(rm_project)
            end
            rm_project.identifier = project.identifier
            rm_project.save
          end
        else
          pending_projects = false
        end
      else
        pending_projects = false
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_trackers
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_trackers
    trackers = RedmineRest::Models::Tracker.all
    if (trackers != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo trackers = "+trackers.size.to_s)
      if (trackers.size > 0) then
        print("\ntengo trackers = "+trackers.size.to_s)
        trackers.each do |tracker|
          print("\ntrato el tracker "+tracker.id.to_s)
          rm_tracker = self.redmine_trackers.find_by_rmid(tracker.id)
          if (not(rm_tracker)) then
            rm_tracker = RedmineTracker.new
            rm_tracker.rmid = tracker.id
            rm_tracker.redmine_server = self
          else
            extra.delete(rm_tracker)
          end
          rm_tracker.name = tracker.name
          rm_tracker.save
        end
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_roles
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_roles
    roles = RedmineRest::Models::Role.all
    if (roles != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo roles = "+roles.size.to_s)
      if (roles.size > 0) then
        print("\ntengo roles = "+roles.size.to_s)
        roles.each do |rol|
          print("\ntrato el rol "+rol.id.to_s)
          rm_rol = self.redmine_roles.find_by_rmid(rol.id)
          if (not(rm_rol)) then
            rm_rol = RedmineRole.new
            rm_rol.rmid = rol.id
            rm_rol.redmine_server = self
          else
            extra.delete(rm_rol)
          end
          rm_rol.name = rol.name
          rm_rol.save
        end
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_groups
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_groups
    groups = RedmineRest::Models::Group.all
    if (groups != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo gtoups = "+groups.size.to_s)
      if (groups.size > 0) then
        print("\ntengo groups = "+groups.size.to_s)
        groups.each do |group|
          print("\ntrato el group "+group.id.to_s)
          rm_group = self.redmine_groups.find_by_rmid(group.id)
          if (not(rm_group)) then
            rm_group = RedmineGroup.new
            rm_group.rmid = group.id
            rm_group.redmine_server = self
          else
            extra.delete(rm_group)
          end
          rm_group.name = group.name
          rm_group.save
        end
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_issue_statuses
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_issue_statuses
    statuses = RedmineRest::Models::IssueStatus.all
    if (statuses != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo statuses = "+statuses.size.to_s)
      if (statuses.size > 0) then
        print("\ntengo statuses = "+statuses.size.to_s)
        statuses.each do |status|
          print("\ntrato el status "+status.id.to_s)
          rm_issue_status = self.redmine_issue_statuses.find_by_rmid(status.id)
          if (not(rm_issue_status)) then
            rm_issue_status = RedmineIssueStatus.new
            rm_issue_status.rmid = status.id
            rm_issue_status.redmine_server = self
          else
            extra.delete(rm_issue_status)
          end
          rm_issue_status.name = status.name
          rm_issue_status.save
        end
      end
    end

    extra.each {|irm|
      irm.delete
    }
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

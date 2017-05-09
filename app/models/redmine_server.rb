class RedmineServer < ActiveRecord::Base
  include RedmineRest::Models
  
  hobo_model # Don't put anything above this

  fields do
    name :string
    url  :string
    admin_api_key :string
    help_server_url :string, :default => nil
    help_project :string, :default => 'help'
    timestamps
  end
  attr_accessible :name, :url, :admin_api_key, :help_server_url

  has_many :redmine_users, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_projects, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_trackers, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_issue_statuses, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_issue_priorities, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_roles, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_groups, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_custom_fields, :dependent => :destroy, :inverse_of => :redmine_server
  has_many :redmine_issues, :through => :redmine_projects, :inverse_of => :redmine_server
  
  children :redmine_projects, :redmine_users, :redmine_trackers, :redmine_issue_statuses, 
    :redmine_roles, :redmine_groups, :redmine_issue_priorities, :redmine_custom_fields
  
  def help_server_root
    if (self.help_server_url == nil) then
      ret = self.url
    else
      ret = self.help_server_url
    end
    return ret
  end

  def help_wiki_prefix
    ret = help_server_root + "/projects/"+self.help_project+"/wiki/Help_"
  end

  def find_issue(rmid)
    ret = self.redmine_issues.find_by_rmid(rmid)
    if (ret == nil) then
      self.reload_all
      self.redmine_projects.each { |pr|
        pr.reload_all
      }
      ret = self.redmine_issues.find_by_rmid(rmid)
    else
      ret.redmine_project.reload_all
    end
    ret.reload_all
    return ret
  end

  def reload_all
    self.reload_trackers
    self.reload_issue_statuses
    self.reload_issue_priorities
    self.reload_roles
    self.reload_custom_fields
    self.reload_groups
    self.reload_users
    self.reload_projects
  end
  
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
            if (project.custom_fields) then
              extracfields = []
              extracfields += rm_project.redmine_project_custom_fields
              project.custom_fields.each{|f|
                print("\n\nTrato el custom field "+f.name)
                cf = RedmineCustomField.find_by_rmid(f.id)
                rm_prj_cfield = rm_project.redmine_project_custom_fields.find_by_redmine_custom_field_id(cf.id)
                if (not(rm_prj_cfield)) then
                  rm_prj_cfield = RedmineProjectCustomField.new
                  rm_prj_cfield.redmine_project = rm_project
                  rm_prj_cfield.redmine_custom_field = cf
                else
                  extracfields.delete(rm_prj_cfield)
                end
                rm_prj_cfield.cfield_name = f.name
                rm_prj_cfield.value = f.value
                rm_prj_cfield.save
              }
              extracfields.each{|ecf|
                ecf.delete
              }
            end
            
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
    trackerspath = RedmineRest::Models::Tracker.collection_path({:project_id => 0})
    print ("\n\nPath: " + trackerspath)
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

  def reload_issue_priorities
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_issue_priorities
    priorities = RedmineRest::Models::IssuePriority.all
    if (priorities != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo priorities = "+priorities.size.to_s)
      if (priorities.size > 0) then
        print("\ntengo priorities = "+priorities.size.to_s)
        priorities.each do |priority|
          print("\ntrato la priority "+priority.id.to_s)
          rm_issue_priority = self.redmine_issue_priorities.find_by_rmid(priority.id)
          if (not(rm_issue_priority)) then
            rm_issue_priority = RedmineIssuePriority.new
            rm_issue_priority.rmid = priority.id
            rm_issue_priority.redmine_server = self
          else
            extra.delete(rm_issue_priority)
          end
          rm_issue_priority.name = priority.name
          rm_issue_priority.save
        end
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_custom_fields
    RedmineRest::Models.configure_models apikey:self.admin_api_key, site:self.url
    
    extra = []
    extra += self.redmine_custom_fields
    cfields = RedmineRest::Models::CustomField.all
    if (cfields != nil) then
      print("\n\n\n\n\n\n\n\n\ntengo cfields = "+cfields.size.to_s)
      if (cfields.size > 0) then
        print("\ntengo cfields = "+cfields.size.to_s)
        cfields.each do |cfield|
          print("\ntrato el cfield "+cfield.id.to_s)
          rm_cfield = self.redmine_custom_fields.find_by_rmid(cfield.id)
          if (not(rm_cfield)) then
            rm_cfield = RedmineCustomField.new
            rm_cfield.rmid = cfield.id
            rm_cfield.redmine_server = self
          else
            extra.delete(rm_cfield)
          end
          rm_cfield.name = cfield.name
          rm_cfield.customized_type = cfield.customized_type
          rm_cfield.field_format = cfield.field_format
          rm_cfield.regexp = cfield.regexp
          rm_cfield.min_length = cfield.min_length
          rm_cfield.max_length = cfield.max_length
          rm_cfield.is_required = cfield.is_required
          rm_cfield.is_filter = cfield.is_filter
          rm_cfield.searchable = cfield.searchable
          rm_cfield.multiple = cfield.multiple
          rm_cfield.default_value = cfield.default_value
          rm_cfield.is_visible = cfield.visible
          rm_cfield.save
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

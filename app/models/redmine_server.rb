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
  
  children :redmine_users, :redmine_projects
  
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

class RedmineServersController < ApplicationController

  hobo_model_controller

  auto_actions :all

  web_method :reload_users
  web_method :reload_projects
  web_method :reload_trackers
  web_method :reload_issue_statuses
  web_method :reload_roles
  web_method :reload_groups
  
  def reload_users
    @redmine_server = find_instance
    @redmine_server.reload_users
    redirect_to this    
  end
  
  def reload_trackers
    @redmine_server = find_instance
    @redmine_server.reload_trackers
    redirect_to this
  end

  def reload_roles
    @redmine_server = find_instance
    @redmine_server.reload_roles
    redirect_to this    
  end

  def reload_groups
    @redmine_server = find_instance
    @redmine_server.reload_groups
    redirect_to this    
  end
  
  def reload_issue_statuses
    @redmine_server = find_instance
    @redmine_server.reload_issue_statuses
    redirect_to this    
  end
  
  def reload_projects
    @redmine_server = find_instance
    @redmine_server.reload_projects
    redirect_to this
  end  
end

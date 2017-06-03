class RedmineServersController < ApplicationController

  hobo_model_controller

  auto_actions :all

  web_method :reload_users
  web_method :reload_projects
  web_method :reload_trackers
  web_method :reload_issue_statuses
  web_method :reload_roles
  web_method :reload_groups
  web_method :reload_issue_priorities
  web_method :reload_custom_fields
  web_method :reload_all

  show_action :issue_help

  def issue_help
    if params[:issue]
      @redmine_server = find_instance
      @issue = @redmine_server.find_issue(params[:issue])
      if (@issue != nil) then
        redirect_to controller: 'redmine_issues', action: 'help', id: @issue.id
      end
    end
  end

  def reload_all
    @redmine_server = find_instance
    @redmine_server.reload_all
    redirect_to this    
  end
  
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
  
  def reload_issue_priorities
    @redmine_server = find_instance
    @redmine_server.reload_issue_priorities
    redirect_to this    
  end
  
  def reload_projects
    @redmine_server = find_instance
    @redmine_server.reload_projects(false)
    redirect_to this
  end  

  def reload_custom_fields
    @redmine_server = find_instance
    @redmine_server.reload_custom_fields
    redirect_to this    
  end
  
end

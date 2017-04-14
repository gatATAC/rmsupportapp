class RedmineProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]
  
  web_method :reload_memberships
  web_method :reload_wikis
  web_method :reload_versions
  web_method :reload_issues
  
  def reload_memberships
    @redmine_project = find_instance
    @redmine_project.reload_memberships
    redirect_to this    
  end
  
  def reload_wikis
    @redmine_project = find_instance
    @redmine_project.reload_wikis
    redirect_to this    
  end
  
  def reload_versions
    @redmine_project = find_instance
    @redmine_project.reload_versions
    redirect_to this    
  end

  def reload_issues
    @redmine_project = find_instance
    @redmine_project.reload_versions
    redirect_to this    
  end

end

class RedmineProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]
  
  web_method :reload_memberships
  
  def reload_memberships
    @redmine_project = find_instance
    @redmine_project.reload_memberships
    redirect_to this    
  end
end

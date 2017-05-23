class RedmineProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]
  
  web_method :reload_memberships
  web_method :reload_wikis
  web_method :reload_versions
  web_method :reload_issues
  web_method :reload_events
  web_method :reload_all
  
  show_action :analysis
  show_action :taskdiagram
  show_action :taskdiagramjson

  def taskdiagram
    @redmine_project = find_instance
    respond_to do |format|
      format.json {
        render :inline => find_instance.to_json
      }
      format.html {
        hobo_show
      }
    end
  end
  
  def analysis
    @redmine_project = find_instance
    @redmine_project.calculate_metrics
    @issues = @redmine_project.redmine_issues.search(params[:search], :subject).order_by(parse_sort_param(:subject)).paginate(:page => params[:page])
    @events = @redmine_project.redmine_issue_events

  end
  
  def reload_all
    @redmine_project = find_instance
    @redmine_project.reload_all
    redirect_to this    
  end
  
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
    @redmine_project.reload_issues
    redirect_to this    
  end

  def reload_events
    @redmine_project = find_instance
    @redmine_project.reload_events
    redirect_to this    
  end

end

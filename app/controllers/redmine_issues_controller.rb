class RedmineIssuesController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]

  show_action :help

  require 'eat'
  def help
  	@redmine_issue = find_instance
	help_server_url = @redmine_issue.redmine_project.redmine_server.help_server_root+'/'
  	### Tracker wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_")
  	@text = '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")

  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
		  	texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_url)
		  	@text += texttmp.gsub('src="/', 'src="'+help_server_url)
  		end
  	}
    @text += '</div>'

  	### Tracker & status wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
  	"_" + @redmine_issue.redmine_issue_status.name.tr(" ", "_")
    @text += '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")
  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
		  	texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_url)
		  	@text += texttmp.gsub('src="/', 'src="'+help_server_url)
  		end
  	}
    @text += '</div>'
  end

end

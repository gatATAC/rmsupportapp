class RedmineIssuesController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]

  show_action :help

  require 'eat'
  
  def scanTextCodes(srv,t)
    ret = t
    base = 0
    encontrado = true
    # Find a Custom Field related particle
    cfstr = "{{cf:"
    cfstrend = "}}"
    while (encontrado) do
      encontrado = false
      indicepr = nil
        indicepr = t.index(cfstr,base)
        if (indicepr != nil) then
        indicepr = indicepr + cfstr.size
        print ("\nBuscamos " + cfstr + ": pos " + indicepr.to_s)
        # Extract the Custom field
        indicepr2 = nil
        indicepr2 = t.index(cfstrend,indicepr)
        if (indicepr2 != nil) then
          print ("\nBuscamos " + cfstrend + ": pos " + indicepr2.to_s)
          # The value is between incidepr+5 and indicepr2
          expcode = t.slice(indicepr, indicepr2 - indicepr)
          print ("\ncfstr: " + cfstr + "\n")
          cf = srv.redmine_custom_fields.find_by_name(expcode)
          if (cf != nil) then
            encontrado = true
            ret += cf.to_s
          end
        end
        base = indicepr2 + cfstrend.size
      end
    end
    return ret
  end
  
  def help
  	@redmine_issue = find_instance
    help_server_url = @redmine_issue.redmine_project.redmine_server.help_server_root+'/'
  	### Tracker wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_")
  	texto2 = '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")

  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
		  	texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_url)
		  	texto2 += texttmp.gsub('src="/', 'src="'+help_server_url)
  		end
  	}
    texto2 += '</div>'
    
  	### Tracker & status wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
      "_" + @redmine_issue.redmine_issue_status.name.tr(" ", "_")
    texto2 += '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")
  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
		  	texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_url)
		  	texto2 += texttmp.gsub('src="/', 'src="'+help_server_url)
  		end
  	}
    texto2 += '</div>'
    @text = self.scanTextCodes(@redmine_issue.redmine_project.redmine_server,texto2)
  end

end

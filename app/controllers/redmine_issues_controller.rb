class RedmineIssuesController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]

  show_action :help

  require 'eat'
  
  def scanTextCodes(srv,t)
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
        indicepr1 = indicepr + cfstr.size
        print ("\nBuscamos " + cfstr + ": pos " + indicepr1.to_s)
        # Extract the Custom field
        indicepr2 = nil
        indicepr2 = t.index(cfstrend,indicepr1)
        if (indicepr2 != nil) then
          print ("\nBuscamos " + cfstrend + ": pos " + indicepr2.to_s)
          # The value is between incidepr+5 and indicepr2
          expcode = t.slice(indicepr1, indicepr2 - indicepr1)
          print ("\ncfstr: " + cfstr + "\n")
          cf = srv.redmine_custom_fields.find_by_name(expcode)
          if (cf != nil) then
            encontrado = true
            # Now it has to obtain the text to substitute the mark
            newtext = "[DUMMYTEXT:"+cf.to_s+"]"
            t = t.slice(0,indicepr)+newtext + t.slice(indicepr2 + cfstrend.size,t.size)
          end
        end
        base = indicepr2 + cfstrend.size
      end
    end
    return t
  end
  
  require 'uri'

  def help
  	@redmine_issue = find_instance
    help_server_url = @redmine_issue.redmine_project.redmine_server.help_server_root+'/'
    uri = URI.parse(help_server_url)
    help_server_root = uri.scheme+'://'+uri.host
    if (uri.port) then
      help_server_root += ":" + uri.port.to_s
    end
    help_server_root += '/'
  	### Tracker wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_")
  	texto2 = '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")

  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
		  	texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_root)
		  	texto2 += texttmp.gsub('src="/', 'src="'+help_server_root)
  		end
  	}
    texto2 += '</div>'
    texto2 += 'This information is extracted from <a href="' + urlstring + '"><b>the help wiki</b></a>'
  	### Tracker & status wiki
  	urlstring = @redmine_issue.redmine_project.redmine_server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
      "_" + @redmine_issue.redmine_issue_status.name.tr(" ", "_")
    texto2 += '<div class="helpwiki">'
  	texto = eat(urlstring)
  	doc = Nokogiri::XML(texto)
  	divs = doc.xpath("//div")
  	divs.each { |dv|
  		if (dv['class']=="wiki wiki-page") then
        texto2 = self.scanTextCodes(@redmine_issue.redmine_project.redmine_server,texto2)
        texttmp = dv.to_s.gsub('href="/', 'href="'+help_server_root)
        texto2 += texttmp.gsub('src="/', 'src="'+help_server_root)
  		end
  	}
    texto2 += '</div>'
    texto2 += 'This information is extracted from <a href="' + urlstring + '"><b>the help wiki</b></a>'
    @text = self.scanTextCodes(@redmine_issue.redmine_project.redmine_server,texto2)
  end

end

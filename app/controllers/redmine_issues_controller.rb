class RedmineIssuesController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]

  show_action :help

  require 'eat'
  
  def scanTextCodes(issue, t)
    prj = issue.redmine_project
    srv = prj.redmine_server
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
            if (issue) then
              cfi = issue.redmine_issue_custom_fields.find_by_redmine_custom_field_id(cf.id)
              if (cfi) then
                newtext = cfi.value.to_s
              else
                if (prj) then
                  cfi = prj.redmine_project_custom_fields.find_by_redmine_custom_field_id(cf.id)
                  if (cfi) then
                    newtext = cfi.value.to_s
                  end
                end
              end
            end
            t = t.slice(0,indicepr) + newtext + t.slice(indicepr2 + cfstrend.size,t.size)
          end
        end
        base = indicepr + newtext.size 
      end
    end
    return t
  end
  
  require 'uri'

  def help_text(urlstring, issue, helpsrvroot)
      ret = ""
      ###  wiki
      #urlstring = @server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
      #  "_*_" + rol.name.tr(" ", "_")
      ret += '<div class="helpwiki">'
      texto = eat(urlstring)
      doc = Nokogiri::XML(texto)
      divs = doc.xpath("//div")
      divs.each { |dv|
        if (dv['class']=="wiki wiki-page") then
          ret = self.scanTextCodes(issue,ret)
          texttmp = dv.to_s.gsub('href="/', 'href="'+helpsrvroot)
          ret += texttmp.gsub('src="/', 'src="'+helpsrvroot)
        end
      }
      ret += '</div>'
      ret += 'This information is extracted from <a href="' + urlstring + '"><b>the help wiki</b></a>'
    
  end
  
  
  def help
    @redmine_issue = find_instance
    @redmine_issue.redmine_project.reload_rm_issue(@redmine_issue)
    #@redmine_issue.redmine_server.reload_all
    @user = @redmine_issue.redmine_user
    @group = @redmine_issue.redmine_group
    @project = @redmine_issue.redmine_project
    @server = @project.redmine_server
    @related_issues = @redmine_issue.redmine_issue_relations
    
    roles_list = []
    if (@user) then
      print @user.to_s+"\n\n"
      print @project.to_s+"\n\n"
      print @server.to_s+"\n\n"
      print @redmine_issue.to_s+"\n\n"
      memb = @user.redmine_memberships.find_by_redmine_project_id(@project.id)
      print @memb.to_s+"\n\n"
      if (@memb != nil) then
        @user_roles = memb.redmine_roles
        roles_list += @user_roles
      end
    else
      @user_roles = nil
    end
    if (@group) then
      memb = @group.redmine_memberships.find_by_redmine_project_id(@project.id)
      @group_roles = memb.redmine_roles
      roles_list += @group_roles
    else
      @group_roles = nil
    end
    # TODO: delete duplicated roles
    help_server_url = @server.help_server_root+'/'
    uri = URI.parse(help_server_url)
    help_server_root = uri.scheme+'://'+uri.host
    if (uri.port) then
      help_server_root += ":" + uri.port.to_s
    end
    help_server_root += '/'
    texto2 = ""
    
    ### Tracker wiki
    urlstring = @server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_")
    texto2 += self.help_text(urlstring, @redmine_issue, help_server_root) 

    ### Tracker & status wiki
    urlstring = @server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
      "_" + @redmine_issue.redmine_issue_status.name.tr(" ", "_")
    texto2 += self.help_text(urlstring, @redmine_issue, help_server_root) 

    roles_list.each {|rol|
      
      ### Tracker & role wiki
      urlstring = @server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
        "_*_" + rol.name.tr(" ", "_")
      texto2 += self.help_text(urlstring, @redmine_issue, help_server_root) 


      ### Tracker & status & role wiki
      urlstring = @server.help_wiki_prefix + @redmine_issue.redmine_tracker.name.tr(" ", "_") + 
        "_" + @redmine_issue.redmine_issue_status.name.tr(" ", "_") + 
        "_" + rol.name.tr(" ", "_")
      texto2 += self.help_text(urlstring, @redmine_issue, help_server_root) 
  }

    # Global replacement of codes
    @text = self.scanTextCodes(@redmine_issue,texto2)
  end

end

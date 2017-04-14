class RedmineProject < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    identifier :string
    rmid :integer    
    timestamps
  end
  attr_accessible :identifier, :rmid
  
  belongs_to :redmine_server, :creator => :true, :inverse_of => :redmine_projects

  has_many :redmine_memberships, :dependent => :destroy, :inverse_of => :redmine_project
  has_many :redmine_wikis, :dependent => :destroy, :inverse_of => :redmine_project
  has_many :redmine_versions, :dependent => :destroy, :inverse_of => :redmine_project
  has_many :redmine_issues, :dependent => :destroy, :inverse_of => :redmine_project
  
  children :redmine_issues, :redmine_versions, :redmine_memberships, :redmine_wikis
  
  def name
    identifier
  end
  
  def reload_all
    self.reload_memberships
    self.reload_wikis
    self.reload_versions
    self.reload_issues
  end
  
  def reload_issues
    RedmineRest::Models.configure_models apikey:self.redmine_server.admin_api_key, site:self.redmine_server.url
    
    pending_issues = true
    pending_offset = 0
    processed_issues = []
    issue_with_parent = []    
    extra = []
    extra += self.redmine_issues
    while (pending_issues) do
      issues = RedmineRest::Models::Issue.where(project_id:self.rmid, offset:pending_offset, order:('id desc'))
      if (issues != nil) then
        print("\n\n\n\n\n\n\n\n\ntengo issues = "+issues.size.to_s+"\n")
        pending_offset += issues.size
        if (issues.size > 0) then
          print("\ntengo issues2 = "+issues.size.to_s)
          issues.each do |issue|
            print("\ntrato la issue "+issue.id.to_s)
            rm_issue = self.redmine_issues.find_by_rmid(issue.id)
            if (not(rm_issue)) then
              rm_issue = RedmineIssue.new
              rm_issue.rmid = issue.id
              rm_issue.redmine_project = self
            else
              extra.delete(rm_issue)
            end
            rm_issue.subject = issue.subject
            rm_issue.description = issue.description
            rm_issue.start_date = issue.start_date
            rm_issue.due_date = issue.due_date
            rm_issue.done_ratio = issue.done_ratio
            rm_issue.estimated_hours = issue.estimated_hours
            rm_issue.author = RedmineUser.find_by_rmid(issue.author.id)
            begin
              assigned_to = issue.assigned_to.id
              tmp = RedmineUser.find_by_rmid(assigned_to)
              if (tmp) then
                rm_issue.redmine_user = tmp
                rm_issue.redmine_group = nil
              else
                tmp = RedmineGroup.find_by_rmid(assigned_to)
                rm_issue.redmine_group = tmp
                rm_issue.redmine_user = nil
              end
            rescue ActiveResource::ResourceNotFound
              rm_issue.redmine_user = nil
              rm_issue.redmine_group = nil
            end
            rm_issue.redmine_tracker = RedmineTracker.find_by_rmid(issue.tracker.id)
            rm_issue.redmine_issue_status = RedmineIssueStatus.find_by_rmid(issue.status.id)
            rm_issue.redmine_issue_priority = RedmineIssuePriority.find_by_rmid(issue.priority.id)
            begin
              rm_issue.redmine_version = RedmineVersion.find_by_rmid(issue.fixed_version.id)
            rescue ActiveResource::ResourceNotFound
              rm_issue.redmine_version = nil
            end
            rm_issue.is_private = issue.is_private.to_sym
            
            begin
              rm_issue.parent_rmid = issue.parent.id            
              issue_with_parent << rm_issue
            rescue ActiveResource::ResourceNotFound
              rm_issue.parent_rmid = nil           
            end
            
            if (issue.custom_fields) then
              extracfields = []
              extracfields += rm_issue.redmine_issue_custom_fields
              issue.custom_fields.each{|f|
                print("\n\nTrato el custom field "+f.name)
                cf = RedmineCustomField.find_by_rmid(f.id)
                rm_issue_cfield = rm_issue.redmine_issue_custom_fields.find_by_redmine_custom_field_id(cf.id)
                if (not(rm_issue_cfield)) then
                  rm_issue_cfield = RedmineIssueCustomField.new
                  rm_issue_cfield.redmine_issue = rm_issue
                  rm_issue_cfield.redmine_custom_field = cf
                else
                  extracfields.delete(rm_issue_cfield)
                end
                rm_issue_cfield.cfield_name = f.name
                rm_issue_cfield.value = f.value
                rm_issue_cfield.save
              }
              extracfields.each{|ecf|
                ecf.delete
              }
            end
            rm_issue.save
            processed_issues << rm_issue
          end
        else
          pending_issues = false
        end
      else
        pending_issues = false
      end
    end

    extra.each {|irm|
      irm.delete
    }

    issue_with_parent.each{|is|
      is.parent = self.redmine_issues.find_by_rmid(is.parent_rmid)
      is.save
    }
    
    processed_issues.each { |issue|
      extra = []
      extra += issue.redmine_issue_relations
      relations = RedmineRest::Models::Relation.where(issue_id:issue.rmid, offset:pending_offset, order:('id desc'))
      relations.each { |relation|
        a = relation.issue_to_id.to_i
        if (a != issue.rmid) then
          rm_issue_relation = issue.redmine_issue_relations.find_by_rmid(relation.id)
          if (not(rm_issue_relation)) then
            rm_issue_relation = RedmineIssueRelation.new
            rm_issue_relation.rmid = relation.id
            rm_issue_relation.redmine_issue = issue
          else
            extra.delete(rm_issue_relation)
          end
          rm_issue_relation.destination_issue = RedmineIssue.find_by_rmid(relation.issue_to_id)
          rm_issue_relation.delay = relation.delay
          rm_issue_relation.relation_type = relation.relation_type
          rm_issue_relation.save
        end
      }
      extra.each {|irm|
        irm.delete
      }
=begin
      issue.redmine_issue_relations.each { |rel|
        if (rel.redmine_issue == rel.destination_issue) then
          rel.delete
        end
      }
=end
      issue.save
    }
  end
  
  def reload_memberships
    RedmineRest::Models.configure_models apikey:self.redmine_server.admin_api_key, site:self.redmine_server.url
    
    pending_members = true
    pending_offset = 0
    extra = []
    extra += self.redmine_memberships
    while (pending_members) do
      members = RedmineRest::Models::Membership.where(project_id:self.rmid, offset:pending_offset, order:('id desc'))
      if (members != nil) then
        print("\n\n\n\n\n\n\n\n\ntengo members1 = "+members.size.to_s+"\n")
        pending_offset += members.size
        if (members.size > 0) then
          print("\ntengo members2 = "+members.size.to_s)
          members.each do |member|
            print("\ntrato el member "+member.id.to_s)
            rm_member = self.redmine_memberships.find_by_rmid(member.id)
            if (not(rm_member)) then
              rm_member = RedmineMembership.new
              rm_member.rmid = member.id
              rm_member.redmine_project = self
            else
              extra.delete(rm_member)
            end
            begin
              rm_member.redmine_user = RedmineUser.find_by_rmid(member.user.id)
              rm_member.redmine_group = nil
            rescue ActiveResource::ResourceNotFound
              rm_member.redmine_group = RedmineGroup.find_by_rmid(member.group.id)
              rm_member.redmine_user = nil
            end
            if (member.roles) then
              member.roles.each{|f|
                rol = RedmineRole.find_by_rmid(f.id)
                if (not(rm_member.redmine_roles.include?(rol))) then
                  rm_member.redmine_roles << rol
                end
              }
            end
            rm_member.save
          end
        else
          pending_members = false
        end
      else
        pending_members = false
      end
    end

    extra.each {|irm|
      irm.delete
    }
  end

  def reload_wikis
    RedmineRest::Models.configure_models apikey:self.redmine_server.admin_api_key, site:self.redmine_server.url
    
    extra = []
    extra += self.redmine_wikis
    wiki_with_parent = []
    
    wikis = RedmineRest::Models::Wiki.where(project_id:self.rmid)
    if (wikis != nil) then
      if (wikis.size > 0) then
        print("\ntengo wikis = "+wikis.size.to_s)
        print("\ntengo extra = "+extra.size.to_s)
        wikis.each do |wiki|
          print("\ntrato el wiki "+wiki.title)
          rm_wiki = self.redmine_wikis.find_by_title(wiki.title)
          if (not(rm_wiki)) then
            print("Creo uno nuevo")
            rm_wiki = RedmineWiki.new
            rm_wiki.title = wiki.title
            rm_wiki.redmine_project = self
          else
            print("Ya existía con extra size"+extra.size.to_s)
            extra.delete(rm_wiki)
            print("Borré y queda extra size"+extra.size.to_s)
          end
          wikipath = RedmineRest::Models::Wiki.element_path(wiki.title, {:project_id => self.rmid})
          wikidetails = RedmineRest::Models::Wiki.find(:one, :from => wikipath)
          rm_wiki.wikitext = wikidetails.text
          rm_wiki.version = wikidetails.version
          
          if (wikidetails.try(:parent).present?) then
            rm_wiki.parent_title = wikidetails.parent.title            
            wiki_with_parent << rm_wiki
          end
          begin
            rm_wiki.redmine_user = RedmineUser.find_by_rmid(wikidetails.author.id)
          rescue ActiveResource::ResourceNotFound
            rm_wiki.redmine_user = nil
          end
          rm_wiki.save
        end
      end
    end
    extra.each {|irm|
      irm.delete
    }
    
    wiki_with_parent.each{|wk|
      wk.parent = self.redmine_wikis.find_by_title(wk.parent_title)
      wk.save
    }
  end

  def reload_versions
    RedmineRest::Models.configure_models apikey:self.redmine_server.admin_api_key, site:self.redmine_server.url
    
    extra = []
    extra += self.redmine_versions
    
    versions = RedmineRest::Models::Version.where(project_id:self.rmid)
    if (versions != nil) then
      if (versions.size > 0) then
        print("\ntengo versions = "+versions.size.to_s)
        print("\ntengo extra = "+extra.size.to_s)
        versions.each do |version|
          print("\ntrato el version "+version.name)
          rm_version = self.redmine_versions.find_by_rmid(version.id)
          if (not(rm_version)) then
            print("Creo uno nuevo")
            rm_version = RedmineVersion.new
            rm_version.rmid = version.id
            rm_version.redmine_project = self
          else
            print("Ya existía con extra size"+extra.size.to_s)
            extra.delete(rm_version)
            print("Borré y queda extra size"+extra.size.to_s)
          end
          rm_version.name = version.name
          rm_version.description = version.description
          rm_version.status = version.status
          rm_version.due_date = version.due_date
          rm_version.sharing = version.sharing
          rm_version.save
        end
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

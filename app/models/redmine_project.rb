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
  
  def reload_issues
  
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

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
  
  children :redmine_memberships
  
  def name
    identifier
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
        print("\n\n\n\n\n\n\n\n\ntengo members = "+members.size.to_s)
        pending_offset += members.size
        if (members.size > 0) then
          print("\ntengo members = "+members.size.to_s)
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

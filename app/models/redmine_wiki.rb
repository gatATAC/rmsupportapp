class RedmineWiki < ActiveRecord::Base

  hobo_model # Don't put anything above this

  acts_as_tree
  
  fields do
    title    :string
    rmid     :integer
    wikitext :text
    version  :integer
    parent_title :string
    timestamps
  end
  attr_accessible :title, :rmid, :wikitext, :version

  belongs_to :redmine_project, :creator => :true, :inverse_of => :redmine_wikis
  belongs_to :redmine_user, :inverse_of => :redmine_wikis
  
  def name
    if self.parent then
      ret = self.parent.name+":"
    else
      ret = ""
    end
    ret += self.title
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

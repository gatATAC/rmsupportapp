require 'will_paginate/collection'

class Array
  # Paginates a static array (extracting a subset of it). The result is a
  # WillPaginate::Collection instance, which is an array with a few more
  # properties about its paginated state.
  #
  # Parameters:
  # * <tt>:page</tt> - current page, defaults to 1
  # * <tt>:per_page</tt> - limit of items per page, defaults to 30
  # * <tt>:total_entries</tt> - total number of items in the array, defaults to
  #   <tt>array.length</tt> (obviously)
  #
  # Example:
  #   arr = ['a', 'b', 'c', 'd', 'e']
  #   paged = arr.paginate(:per_page => 2)      #->  ['a', 'b']
  #   paged.total_entries                       #->  5
  #   arr.paginate(:page => 2, :per_page => 2)  #->  ['c', 'd']
  #   arr.paginate(:page => 3, :per_page => 2)  #->  ['e']
  #
  # This method was originally {suggested by Desi
  # McAdam}[http://www.desimcadam.com/archives/8] and later proved to be the
  # most useful method of will_paginate library.
  def paginate(options = {})
    page     = options[:page] || 1
    per_page = options[:per_page] || WillPaginate.per_page
    total    = options[:total_entries] || self.length

    WillPaginate::Collection.create(page, per_page, total) do |pager|
      pager.replace self[pager.offset, pager.per_page].to_a
    end
  end

  attr_accessor :member_class, :origin, :origin_attribute

  # Hobo Extension
  def to_url_path
    base_path = origin.try.to_url_path
    "#{base_path}/#{origin_attribute}" unless base_path.blank?
  end

  # Hobo Extension
  def typed_id
    origin and origin_id = origin.try.typed_id and "#{origin_id}:#{origin_attribute}"
  end

  # Hobo Extension
  def paginate_with_hobo_metadata(*args, &block)
    collection = paginate_without_hobo_metadata(*args, &block)
    collection.member_class     = member_class
    collection.origin           = try.proxy_owner
    collection.origin_attribute = try.proxy_association._?.reflection._?.name
    collection
  end
  alias_method_chain :paginate, :hobo_metadata

end

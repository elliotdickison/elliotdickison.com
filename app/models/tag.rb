class Tag < ActiveRecord::Base
  validates :name, presence: true

  has_many :taggings
  has_many :posts, :through => :taggings, :source => :taggable, :source_type => 'Post'

  before_validation do
    self.name = name.strip if attribute_present?('name')
  end

  def find_by_name(name)
    find(:all, :conditions => ["name = ?", name])
  end

  def link
    "/tags/#{id}"
  end
end
class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  has_many :taggings
  has_many :posts, :through => :taggings, :source => :taggable, :source_type => 'Post'

  before_validation do
    self.name = name.strip if attribute_present?('name')
  end

  def find_by_name(name)
    self.find(:all, :conditions => ["lower(name) = ?", name.downcase])
  end

  def link
    "/blog/tags/#{self.id}"
  end
end
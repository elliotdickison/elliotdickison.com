class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  validates :reference_id, presence: true

  has_many :comments
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  before_validation do
    self.reference_id = reference_id.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '') if attribute_present?('reference_id')
  end

  def publish!
    self.touch :published_at unless self.published_at
  end

  def to_s
    RDiscount.new(self.body, :smart).to_html
  end

  def to_short_s
    short = self.body
      .split(/\n/)
      .map { |chunk| chunk.strip }
      .keep_if { |chunk| chunk.length > 0 && !chunk.start_with?('#') }
      .first
    RDiscount.new(short, :smart).to_html
  end

  def link
    if self.published_at
  	  "/blog/#{self.published_at.strftime('%Y')}/#{self.reference_id}"
    else
      "/posts/#{self.id}"
    end
  end
end
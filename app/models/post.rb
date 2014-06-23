class Post < ActiveRecord::Base
  
  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true

  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  before_validation :format_slug

  before_save :render_body

  def format_slug
    self.slug = slug.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '') if attribute_present?('slug')
  end

  def render_body
    redcarpet = Redcarpet::Markdown.new HtmlWithGoodies, {fenced_code_blocks: true}
    self.rendered_body = redcarpet.render body
  end

  def publish!
    touch :published_at unless published_at
  end

  def to_s
    rendered_body || ''
  end

  def link
    if published_at
  	  "/#{slug}"
    else
      "/posts/#{id}"
    end
  end
end
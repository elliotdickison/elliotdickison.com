class Post < ActiveRecord::Base
  
  validates :title, presence: true
  validates :body, presence: true
  validates :reference_id, presence: true

  has_many :comments
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  before_validation :scrub_inputs

  before_save :render_body

  def scrub_inputs
    self.reference_id = reference_id.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '') if attribute_present?('reference_id')
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

  def to_short_s
    rendered_body
      .split(/\n/)
      .map { |chunk| chunk.strip }
      .keep_if { |chunk| chunk.length > 0 && chunk.start_with?('<p>') }
      .first
  end

  def link
    if published_at
  	  "/blog/#{published_at.strftime('%Y')}/#{reference_id}"
    else
      "/posts/#{id}"
    end
  end
end
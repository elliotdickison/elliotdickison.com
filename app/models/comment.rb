class Comment < ActiveRecord::Base
  
  validates :commenter, presence: true
  validates :email, presence: true, email: true
  validates :website, url: true, allow_blank: true
  validates :body, presence: true

  belongs_to :post

  before_validation :scrub_inputs

  before_save :render_body

  def scrub_inputs
    self.commenter = Rack::Utils.escape_html commenter if attribute_present?('commenter')
    self.website = '//' << website if attribute_present?('website') and not website.blank? and not website.include?('//')
  end

  def render_body
    redcarpet = Redcarpet::Markdown.new HtmlWithGoodies, {filter_html: true, safe_links_only: true, no_styles: true}
    self.rendered_body = redcarpet.render body
  end

  def gravatar_src
  	'http://www.gravatar.com/avatar/' << Digest::MD5.hexdigest(email.downcase) << '?d=retro'
  end

  def to_s
    rendered_body || ''
  end
end
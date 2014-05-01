class Comment < ActiveRecord::Base
  validates :commenter, presence: true
  validates :email, presence: true, email: true
  validates :website, url: true, allow_blank: true
  validates :body, presence: true

  belongs_to :post

  before_validation do
    self.commenter = Rack::Utils.escape_html commenter if attribute_present?('commenter')
    self.website = '//' << website if attribute_present?('website') and not website.blank? and not website.include?('//')
  end

  before_save do
    self.rendered_body = RDiscount.new(body, :smart, :filter_html).to_html
  end

  def gravatar_src
  	'http://www.gravatar.com/avatar/' << Digest::MD5.hexdigest(email.downcase) << '?d=retro'
  end

  def to_s
    rendered_body || ''
  end
end
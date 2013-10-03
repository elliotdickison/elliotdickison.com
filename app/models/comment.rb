class Comment < ActiveRecord::Base
  validates :commenter, presence: true
  validates :email, presence: true
  validates :body, presence: true

  belongs_to :post

  before_validation do
    self.commenter = Rack::Utils.escape_html commenter if attribute_present?('commenter')
    self.email = Rack::Utils.escape_html email if attribute_present?('email')
    self.website = Rack::Utils.escape_html website if attribute_present?('website')
  end

  def body
    RDiscount.new(read_attribute(:body), :smart, :filter_html).to_html
  end

  def gravatar_src
  	'http://www.gravatar.com/avatar/' << Digest::MD5.hexdigest(self.email.downcase) << '?d=retro'
  end

  def to_s
    self.body
  end
end
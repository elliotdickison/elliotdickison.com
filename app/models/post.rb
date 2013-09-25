class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  validates :reference_id, presence: true

  has_many :comments

  before_validation do
    self.reference_id = reference_id.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '') if attribute_present?('reference_id')
  end

  def to_s
    self.body
  end

  def link
  	'/blog/' << self.created_at.strftime('%Y') << '/' << self.reference_id
  end
end
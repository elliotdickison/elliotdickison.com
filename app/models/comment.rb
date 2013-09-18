class Comment < ActiveRecord::Base
  validates :commenter, presence: true
  validates :email, presence: true
  validates :body, presence: true

  belongs_to :post

  def gravatar_src
  	'http://www.gravatar.com/avatar/' << Digest::MD5.hexdigest(self.email.downcase) << '?d=retro'
  end

  def to_s
    self.body
  end
end
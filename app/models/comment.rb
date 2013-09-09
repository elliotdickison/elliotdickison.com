class Comment < ActiveRecord::Base
  validates :commenter, presence: true
  validates :email, presence: true
  validates :body, presence: true

  belongs_to :post

  def to_s
    self.body
  end
end
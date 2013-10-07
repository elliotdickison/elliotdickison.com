class Message < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :body, presence: true

  def to_s
    self.body
  end
end
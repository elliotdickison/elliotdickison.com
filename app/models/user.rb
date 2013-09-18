class User < ActiveRecord::Base
  validates :name, presence: true
  validates :password, presence: true

  # validate email here

  def self.authenticate(name, password)
  	User.find_by name: name, password: Digest::MD5.hexdigest(password)
  end

  def is_admin?
  	true
  end

  def to_s
    self.name
  end
end
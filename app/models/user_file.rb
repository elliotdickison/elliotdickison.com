class UserFile < ActiveRecord::Base
  validates :name, presence: true
  validates :extension, presence: true

  def to_s
    "#{name}.#{extension}"
  end
end
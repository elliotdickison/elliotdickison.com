class UserFile < ActiveRecord::Base
  validates :name, presence: true
  validates :extension, presence: true

  def to_s
    "#{self.name}.#{self.extension}"
  end
end
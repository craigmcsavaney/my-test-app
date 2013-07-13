class Role < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :users

end

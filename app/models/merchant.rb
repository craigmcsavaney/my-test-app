class Merchant < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  has_many :promotions, dependent: :destroy
end

class Merchant < ActiveRecord::Base
	has_and_belongs_to_many :users

  	attr_accessible :name, :user_ids
  	validates :name, presence: true, uniqueness: { case_sensitive: false }

  	has_many :promotions, dependent: :destroy

  	delegate :user_id, to: :promotion
end

class Merchant < ActiveRecord::Base
	include NotDeleteable
	versioned
	
	has_and_belongs_to_many :users

  	attr_accessible :name, :user_ids, :website

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :website, url: true

  	has_many :promotions, dependent: :destroy

  	delegate :user_id, to: :promotion


end

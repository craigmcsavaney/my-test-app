class Serve < ActiveRecord::Base
	include NotDeleteable
	versioned

	attr_accessible :promotion_id, :email

	belongs_to :promotion
	has_many :shares
	validates :promotion, presence: true
	validates :promotion_id, presence: true


end

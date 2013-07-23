class Serve < ActiveRecord::Base
	attr_accessible :promotion_id

	belongs_to :promotion
	validates :promotion, presence: true
	validates :promotion_id, presence: true


end

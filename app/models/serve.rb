class Serve < ActiveRecord::Base
	include NotDeleteable
	versioned

	attr_accessible :promotion_id, :email, :share_id, :viewed

	after_commit :create_purchase_share, on: :create

	belongs_to :promotion, counter_cache: true
	belongs_to :share
	has_many :shares
	validates :promotion, presence: true
	validates :promotion_id, presence: true

	def self.not_exists?(id)
    		self.find(id)
    		false
  		rescue
    		true
  	end

  	def create_purchase_share
		Share.create_purchase_share(self)
  	end

end

class Sale < ActiveRecord::Base
  	include NotDeleteable
	versioned

	attr_accessible :amount, :transaction_id, :deleted, :share_id, :supporter_share_id, :buyer_share_id

  	belongs_to :share, counter_cache: true
  	belongs_to :supporter, class_name: "Share", foreign_key: "supporter_share_id"
  	belongs_to :buyer, class_name: "Share", foreign_key: "buyer_share_id"
  	delegate :serve, :to => :share, :allow_nil => true

	monetize :amount_cents, 
		:numericality => {
	    :greater_than_or_equal_to => 0
	  }

	validates :share, presence: true
	validates :share_id, presence: true

	after_validation :set_supporter_share_id, :set_buyer_share_id

	after_commit :create_all_donations, on: :create

  	def self.is_a_number?(amount)
	    !!(amount =~ /\A[+-]?\d+?(\.\d+)?\Z/)
  	end

  	def self.only_dollars_and_cents(amount)
	    (100*amount) == (100*amount).to_i
  	end

  	# set_buyer_share_id determines if there is a buyer associated with this sale and if so, sets the buyer_share_id to the share_id associated with the purchase share, but only if this sale is linked to a purchase path (meaning, the purchase was made by a user who had previously viewed the causebutton widget).  Note that there can be a buyer associated with a sale without there being a buyer-directed donation.
  	private
	def set_buyer_share_id
		if self.share.channel.name.downcase == "purchase"
			self.buyer_share_id = self.share.id
		end
	end

  	# set_supporter_share_id determines if there is a supporter associated with this sale and if so, sets the supporter_share_id to the share_id associated with the supporter's share.    Note that there can be a supporter associated with a sale without there being a supporter-directed donation.
	private
	def set_supporter_share_id
		# first, determine if this sale is associated with a purchase share
		purchase_path = self.share.channel.name.downcase == "purchase"
		# next, check to see if this sale is associated with a serve that was actually shared (meaning that the visitor posted to at least one channel before making a purchase).
		shared = Serve.shared?(self.serve)
		# next, check to see if this sale is associated with a serve that has a parent, meaning that it was created as the result of a visitor arriving at this site through link that was created from a different serve.
		has_parent = !self.serve.referring_share_id.nil?
		# finally, set the supporter_share_id variable to nil.  It will remain nil in the following cases:
		# 1. When the buyer was not referred and didn't share the serve (purchase_path && !shrared && !has_parent) before making a purchase
		# 2. When the buyer was not referred and did share the serve before making a purchase, but there is a buyer-directed donation associated with this promotion (purchase_path && shared && !has_parent && buyer_pct > 0).  For this sale, the buyer will only get credit for the buyer contribution and there will be no supporter-directed contribution.
		supporter_share_id = nil

		case 

			# first case, when the purchase was made by a visitor that had not opened the CB Widget.  In this case, the supporter is always the creator of the link that was used by the visitor to reach the site.
			when !purchase_path
				supporter_share_id = self.share.id

			# second case, when the purchase was made by visitor was referred and that had viewed the CB Widget but had not shared the promotion into any of thier channels.  In this case, the supporter is the one who referred the current visitor. 
			when purchase_path && !shared && has_parent
				supporter_share_id = self.share.serve.share.id

			# third case, when the purchase was made by a visitor that had viewed the CB Widget and had shared the promotion through at least one channel, but the promotion does not offer any buyer-directed incentive.  In this case, we give the buyer credit for being a supporter that basically referred themselves to the site, but we only give this credit if they have already shared to at least one channel.
			when purchase_path && shared && self.serve.promotion.buyer_pct == 0
				supporter_share_id = self.share.id

			# final case, when the purchase was made by a visitor that had viewed the CB Widget and had shared the promotion through at least one channel, and for which the promotion does offer a buyer-direted incentive.  In this case, the supporter is the one who referred the current visitor (who gets the buyer credit)
			when purchase_path && shared && has_parent && self.serve.promotion.buyer_pct > 0
				supporter_share_id = self.share.serve.share.id

		end

		# now, set the supporter_share_id value of the current sale object to the correct value
		self.supporter_share_id = supporter_share_id

	end
	
	# create_all_donations runs immediately after the sale commit and relies on the sale.buyer and sale.supporter values set just before the commit.  This method creates donations for all three contribution types, but only for those that have non-zero contribution percentages.
	private
	def create_all_donations
		if self.supporter.nil?
				supporter_id = nil
			else
				supporter_id = self.supporter.serve.user_id
		end
		if self.buyer.nil?
				buyer_id = nil
			else
				buyer_id = self.buyer.serve.user_id
		end
		if self.serve.promotion.merchant_pct > 0
			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: self.serve.promotion.cause_id,
				chosen_by: "merchant",
				amount_cents: (self.amount_cents * ((self.serve.promotion.merchant_pct).to_f/100)).round,
				supporter_id: supporter_id,
				buyer_id: buyer_id
				)
		end

		if !self.buyer.nil? && self.buyer.promotion.buyer_pct > 0 
			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause(self.buyer).id,
				chosen_by: "buyer",
				amount_cents: (self.amount_cents * ((self.buyer.promotion.buyer_pct).to_f/100)).round,
				choosers_email: self.buyer.serve.email,
				chooser_id: buyer_id
				)
		end

		if !self.supporter.nil? && self.supporter.promotion.supporter_pct > 0

			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause(self.supporter).id,
				chosen_by: "supporter",
				amount_cents: (self.amount_cents * ((self.supporter.promotion.supporter_pct).to_f/100)).round,
				choosers_email: self.supporter.serve.email,
				chooser_id: supporter_id
				)

		end

	end

end

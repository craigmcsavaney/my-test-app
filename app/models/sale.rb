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
  		s = amount
  		l = s.index('.')
  		if s.length > l+2+1
  			s[l+2+1,s.length].to_f == 0
  		else
  			true
  		end

	    #(100*amount) == (100*amount).to_i
  	end

  	# set_buyer_share_id determines if there is a buyer associated with this sale and if so, sets the buyer_share_id to the share_id associated with the purchase share, but only if this sale is associated with a serve that has been shared (meaning, the purchase was made by a user who had previously viewed the causebutton widget and shared to at least one channel).  Note that there can be a buyer associated with a sale without there being a buyer-directed donation.
  	private
	def set_buyer_share_id
		if Serve.shared?(self.serve)
			self.buyer_share_id = self.share.id
		end
	end

  	# set_supporter_share_id determines if there is a supporter associated with this sale and if so, sets the supporter_share_id to the share_id associated with the supporter's share.    Note that there can be a supporter associated with a sale without there being a supporter-directed donation.
	private
	def set_supporter_share_id
		# Note that in order for the sale to be valid, either the serve was shared or had a valid referrer, or both, so we can ignore the !shared && !referred case

		# First, check to see if this sale is associated with a serve that was actually shared (meaning that the visitor posted to at least one channel before making a purchase).
		shared = Serve.shared?(self.serve)

		# next, check to see if this sale is associated with a serve that has a parent, meaning that it was created as the result of a visitor arriving at this site through link that was created from a different serve.
		referred = Serve.referred?(self.serve)

		# finally, set the supporter_share_id variable to nil.  All the possible cases should be handled below, so this is just a precaution.
		supporter_share_id = nil

		case 

			# first case, when the purchase was made by a referred visitor.  In this case, the supporter is always the creator of the link that was used by the visitor to reach the site.
			when referred
				supporter_share_id = self.serve.share.id

			# following cases are for !referred && shared, as referred is handled above and !referred && !shared will not produce a sale

			# second case, when the purchase was made by a non-referred visitor that had viewed the CB Widget and had shared the promotion through at least one channel, but the promotion does not offer any buyer-directed incentive.  In this case, we give the buyer credit for being a supporter that basically referred themselves to the site.
			when self.serve.promotion.buyer_pct == 0
				supporter_share_id = self.share.id

			# final case, when the buyer was not referred and did share the serve before making a purchase, but there is a buyer-directed donation associated with this promotion.  For this sale, the buyer will only get credit for the buyer contribution and there will be no supporter-directed contribution.
			when self.serve.promotion.buyer_pct > 0
				supporter_share_id = nil

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
				cause_id: self.serve.default_cause_id,
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
				cause_id: Share.get_cause_id(self.buyer),
				chosen_by: "buyer",
				amount_cents: (self.amount_cents * ((self.buyer.promotion.buyer_pct).to_f/100)).round,
				chooser_id: buyer_id
				)
		end

		if !self.supporter.nil? && self.supporter.promotion.supporter_pct > 0

			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause_id(self.supporter),
				chosen_by: "supporter",
				amount_cents: (self.amount_cents * ((self.supporter.promotion.supporter_pct).to_f/100)).round,
				chooser_id: supporter_id
				)

		end

	end

end

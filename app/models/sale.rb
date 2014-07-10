class Sale < ActiveRecord::Base
  	include NotDeleteable
	versioned

	attr_accessible :amount, :transaction_id, :deleted, :share_id, :supporter_share_id

  	has_many :donations
  	belongs_to :share, counter_cache: true
  	belongs_to :supporter, class_name: "Share", foreign_key: "supporter_share_id"
  	delegate :serve, :to => :share, :allow_nil => true

	monetize :amount_cents, 
		:numericality => {
	    :greater_than_or_equal_to => 0
	  }

	validates :share, presence: true
	validates :share_id, presence: true

	after_validation :set_supporter_share_id

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

  	# set_supporter_share_id determines if there is a supporter associated with this sale and if so, sets the supporter_share_id to the share_id associated with the supporter's share.    Note that there can be a supporter associated with a sale without there being a supporter-directed donation.
	private
	def set_supporter_share_id
		# Note that in order for the sale to be valid, either the serve was shared or had a valid referrer, or both, so we can ignore the !shared && !referred case

		# First, set the supporter_share_id variable to nil.  The two scenarios in which a supporter exists are handled below, and in all other cases there will not be a supporter.
		supporter_share_id = nil

		case 

			# first case, when the purchase was made by a referred visitor.  In this case, the supporter is always the creator of the link that was used by the visitor to reach the site.
			when Serve.referred?(self.serve)
				supporter_share_id = self.serve.share.id

			# second case, when the purchase was made by a non-referred visitor that had viewed the CB Widget and had shared the promotion through at least one channel, but the promotion does not offer any buyer-directed incentive.  In this case, we give the buyer credit for being a supporter that basically referred themselves to the site.
			when self.serve.promotion.buyer_pct == 0
				supporter_share_id = self.share.id

			# in the case where the buyer was not referred and did share the serve before making a purchase, but there is a buyer-directed donation associated with this promotion, we do not treat the buyer as a supporter.  The buyer will only get credit for the buyer contribution and there will be no supporter-directed contribution.  No action is necessary as the supporter_share_id is already nil.

		end

		# now, set the supporter_share_id value of the current sale object to the correct value
		self.supporter_share_id = supporter_share_id

	end
	
	# create_all_donations runs immediately after the sale commit and relies on the sale and sale.supporter values set just before the commit.  This method creates donations for all three contribution types, but only for those that have non-zero contribution percentages.
	private
	def create_all_donations
		# get the supporter's user id as supporter_id.  If no supporter exists for this sale, supporter_id will be nil.  If a supporter_id exists for this sale but there is no user associated with that supporter share, supporter_id will be nil.  If there is a supporter share and there is a user associated with that share, supporter_id will be that user's id.
		if self.supporter.nil?
				supporter_id = nil
			else
				supporter_id = self.supporter.serve.user_id
		end

		# get the buyer's user id as buyer_id.  The buyer is always the user associated with the current serve via the purchase share, which is always the share_id associated with this sale, or Sale.share_id.  The serve associated with sale can always be accessed as Sale.serve.  If there is a user_id associated with the serve, it is Sale.serve.user_id.  If no buyer user exists for this sale, Sale.serve.user_id will be nil.
		buyer_id = self.serve.user_id

		# now check to see if the serve was shared by the buyer at the time of the purchase.  If it was, the purchase may generate either a supporter self-referral donation or a buyer donation (depending on percentages)
		shared = Serve.shared?(self.serve)

		# if there is a merchant donation percentage, the merchant always makes a donation.  However, because the chooser_id is intended to point to a user_id, we leave it blank as the "chooser" in this case is the merchant, not a user.
		if self.serve.promotion.merchant_pct > 0
			merchant_donation = Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: self.serve.default_cause_id,
				chosen_by: "merchant",
				amount_cents: (self.amount_cents * ((self.serve.promotion.merchant_pct).to_f/100)).round,
				supporter_id: supporter_id, # might be nil
				buyer_id: buyer_id, # might be nil
				chooser_id: nil # might be nil
				)
		end

		# if there is a supporter associated with this sale, and the supporter_pct is >0, there will always be a supporter donation. If either if these is not true, there will never be a supporter donation.  Because we catch and prevent self-referrals in the serve api, the sale share will always point to a different serve than the supporter share.  Thus if a supporter exists and supporter_pct > 0, a donation gets made.  We deal with buyer self-referrals below. 
		if !self.supporter.nil? && self.supporter.promotion.supporter_pct > 0
			supporter_donation = Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause_id(self.supporter),
				chosen_by: "supporter",
				amount_cents: (self.amount_cents * ((self.supporter.promotion.supporter_pct).to_f/100)).round,
				chooser_id: supporter_id, # might be nil
				buyer_id: buyer_id, # might be nil
				supporter_id: supporter_id # might be nil
				)
		end

		# Buyer self-referral case.  In this case, there is no supporter associated with the sale, there is a supporter donation available, there is no buyer donation available, and the buyer shared before purchasing.  In this case, we treat the buyer as self-referred and credit them with the supporter donation.

		if self.supporter.nil? && self.serve.promotion.supporter_pct > 0 && shared && self.serve.promotion.buyer_pct == 0

			buyer_donation = Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause_id(self.share),
				chosen_by: "supporter buyer",
				amount_cents: (self.amount_cents * ((self.serve.promotion.supporter_pct).to_f/100)).round,
				chooser_id: buyer_id, # might be nil
				buyer_id: buyer_id, # might be nil
				supporter_id: nil # definitely nil - no supporter in this case
				)

		end

		# Finally, create buyer donations.  There are two conditions that must be met for a buyer donation to be made: the buyer percentage must be >0, and the buyer must have shared.  If either of these is not true, no buyer donation gets made.  Any time these two conditions are are met, a buyer donation gets made.  

		if shared && self.serve.promotion.buyer_pct > 0 
			buyer_donation = Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: Share.get_cause_id(self.share),
				chosen_by: "buyer",
				amount_cents: (self.amount_cents * ((self.serve.promotion.buyer_pct).to_f/100)).round,
				chooser_id: buyer_id, # might be nil
				buyer_id: buyer_id, # might be nil
				supporter_id: supporter_id # might be nil
				)
		end

		# send_sale_with_donations_email

	end

	# private
	# def send_sale_with_donations_email
	# 	# always send the merchant an email if there were any donations made
	# 	if self.donations.sum("amount_cents") > 0
	# 		total = (self.donations.sum("amount_cents")/100).to_f
	# 		if self.serve.merchant.users.count >= 1
	# 			email = self.serve.merchant.users.first.email
	# 			DonationMailer.merchant_sale_email(email,total,merchant_donation,supporter_donation,buyer_donation).deliver
	# 		end


	# 	# send_merchant_donation_email
	# 	# # if there is a buyer donation, always send the buyer an email
	# 	# send_buyer_donation_email

	# 	# 	if self.chosen_by == "merchant"
	# 	# 	# Merchants can have multiple users, and possibly no users.  If users exist for this merchant, get the email address of the first one found.  Otherwise, skip this message.

	# 	end


		
	# end

end

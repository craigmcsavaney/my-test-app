class Sale < ActiveRecord::Base
  	include NotDeleteable
	versioned

	attr_accessible :amount, :transaction_id, :deleted, :share_id

  	belongs_to :share#, counter_cache: true
  	delegate :serve, :to => :share, :allow_nil => true

	monetize :amount_cents, 
		:numericality => {
	    :greater_than_or_equal_to => 0
	  }

	validates :share, presence: true
	validates :share_id, presence: true

	after_commit :create_all_donations, on: :create

  	def self.is_a_number?(amount)
	    !!(amount =~ /\A[+-]?\d+?(\.\d+)?\Z/)
  	end

  	def self.only_dollars_and_cents(amount)
	    (100*amount) == (100*amount).to_i
  	end

  	private
	def create_all_donations
		if self.serve.promotion.merchant_pct > 0
			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: self.serve.promotion.cause_id,
				chosen_by: "merchant",
				amount_cents: (self.amount_cents * ((self.serve.promotion.merchant_pct).to_f/100)).round,
				)
		end

		if self.serve.promotion.buyer_pct > 0 && self.share.channel.name.downcase == "purchase"
			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: self.serve.promotion.cause_id,
				chosen_by: "buyer",
				amount_cents: (self.amount_cents * ((self.serve.promotion.buyer_pct).to_f/100)).round,
				choosers_email: self.serve.email
				)
		end

		purchase_path = self.share.channel.name.downcase == "purchase"
		shared = Serve.shared?(self.serve)
		has_parent = !self.serve.referring_share_id.nil?
		supporter = false

		case 

			when !purchase_path
				supporter = true
				supporter_pct = self.serve.promotion.supporter_pct
				cause = Share.get_cause(self.share)
				email = self.serve.email

			when purchase_path && !shared && has_parent
				supporter = true
				supporter_pct = self.serve.share.serve.promotion.supporter_pct
				cause = Share.get_cause(self.serve.share)
				email = self.serve.share.serve.email

			when purchase_path && shared && self.serve.promotion.buyer_pct == 0
				supporter = true
				supporter_pct = self.serve.promotion.supporter_pct
				cause = Share.get_cause(self.share)
				email = self.serve.email

			when purchase_path && shared && has_parent && self.serve.promotion.buyer_pct > 0
				supporter = true
				supporter_pct = self.serve.share.serve.promotion.supporter_pct
				cause = Share.get_cause(self.serve.share)
				email = self.serve.share.serve.email

		end

		if supporter && supporter_pct > 0

			Donation.create(
				sale_id: self.id,
				merchant_id: self.serve.merchant.id,
				cause_id: cause.id,
				chosen_by: "supporter",
				amount_cents: (self.amount_cents * ((supporter_pct).to_f/100)).round,
				choosers_email: email
				)

		end

	end

end

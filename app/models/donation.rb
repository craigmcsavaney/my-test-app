class Donation < ActiveRecord::Base
  	include NotDeleteable
	versioned
    
    attr_accessible :sale_id, :merchant_id, :cause_id, :chosen_by, :amount, :amount_cents, :choosers_email, :chooser_id, :supporter_id, :buyer_id

  	belongs_to :sale
  	delegate :share, :to => :sale, :allow_nil => true
  	belongs_to :merchant
  	belongs_to :cause
  	belongs_to :chooser, class_name: "User", foreign_key: "chooser_id" 
  	belongs_to :supporter, class_name: "User", foreign_key: "supporter_id" 
  	belongs_to :buyer, class_name: "User", foreign_key: "buyer_id" 

  	validates :sale, presence: true
	validates :sale_id, presence: true
  	validates :merchant, presence: true
	validates :merchant_id, presence: true
  	validates :cause, presence: true
	validates :cause_id, presence: true

  	monetize :amount_cents, 
		:numericality => { :greater_than_or_equal_to => 0 }

	after_commit :send_donation_email, on: :create

	private
	def send_donation_email
		if self.choosers_email != "" && !self.choosers_email.nil?
			DonationMailer.donation_email(self,self.choosers_email).deliver
		elsif self.chosen_by = "merchant"
			if !self.sale.buyer.nil? && self.sale.buyer.serve.email != "" && !self.sale.buyer.serve.email.nil?
				DonationMailer.donation_email(self,self.sale.buyer.serve.email).deliver
			end

			if !self.sale.supporter.nil? && self.sale.supporter.serve.email != "" && !self.sale.supporter.serve.email.nil?
				DonationMailer.donation_email(self,self.sale.supporter.serve.email).deliver
			end
		end
			
	end


end

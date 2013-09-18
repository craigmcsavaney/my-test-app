class Donation < ActiveRecord::Base
  	include NotDeleteable
	versioned
    
    attr_accessible :sale_id, :merchant_id, :cause_id, :chosen_by, :amount, :amount_cents, :choosers_email

  	belongs_to :sale  #, counter_cache: true
  	delegate :share, :to => :sale, :allow_nil => true
  	belongs_to :merchant
  	belongs_to :cause

  	validates :sale, presence: true
	validates :sale_id, presence: true
  	validates :merchant, presence: true
	validates :merchant_id, presence: true
  	validates :cause, presence: true
	validates :cause_id, presence: true

  	monetize :amount_cents, 
		:numericality => { :greater_than_or_equal_to => 0 }

end

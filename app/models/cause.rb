class Cause < ActiveRecord::Base
	include NotDeleteable
	versioned
	
  	attr_accessible :name, :user_ids
  	validates :name, presence: true, uniqueness: { case_sensitive: false }

  	has_and_belongs_to_many :users
  	has_many :promotions
  	has_many :shares
end

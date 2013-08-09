class Merchant < ActiveRecord::Base
	include NotDeleteable
	versioned
	
	has_and_belongs_to_many :users

  	attr_accessible :name, :user_ids, :website, :deleted

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :website, url: true

  	has_many :promotions, dependent: :destroy
  	has_many :serves, through: :promotions
  	has_many :shares, through: :serves

  	delegate :user_id, to: :promotion

  def self.not_exists?(id)
      self.find(id)
      false
    rescue
      true
  end

end

class Cause < ActiveRecord::Base
	include NotDeleteable
	versioned
	
  	attr_accessible :name, :user_ids, :deleted

    before_validation :generate_uid

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :uid, presence: true, uniqueness: { case_sensitive: true }

  	has_and_belongs_to_many :users
  	has_many :promotions
  	has_many :shares
  	has_many :serves

  	def self.not_exists?(id)
  		self.find(id)
  		false
		rescue
  		true
	  end

  protected
  def generate_uid
    self.uid = loop do
      uid = SecureRandom.urlsafe_base64(8, false)
      break uid unless Cause.where(uid: uid).exists?
    end
  end

end

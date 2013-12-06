class Event < ActiveRecord::Base
	include NotDeleteable
    versioned

  	attr_accessible :name, :description, :order, :deleted, :event_date, :start_date, :end_date, :group_id, :uid

  	belongs_to :group
  	has_many :promotions

  	before_validation :generate_uid

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :group_id, presence: true, :uniqueness => {message: ":: The Cause Group you selected is already associated with an event.  Please pick another Cause Group for this Event."}, numericality: true
  	validates :event_date, presence: true
  	validates :start_date, presence: true
  	validates :uid, presence: true, uniqueness: { case_sensitive: true }


  	protected
	def generate_uid
	    if self.uid.nil? || self.uid == ""
	      self.uid = loop do
	        uid = SecureRandom.urlsafe_base64(8, false)
	        break uid unless Event.where(uid: uid).exists?
	      end
	    end
	end

end

class Merchant < ActiveRecord::Base
	include NotDeleteable
	versioned

	attr_accessible :name, :user_ids, :website, :button_id, :logo_link, :uid, :deleted, :widget_position_id, :auto_button_id

	has_and_belongs_to_many :users
	has_many :promotions, dependent: :destroy
	has_many :serves, through: :promotions
	has_many :donations
	belongs_to :button
	belongs_to :widget_position
	belongs_to :auto_button

	before_validation :generate_uid

	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :website, url: true
	validates :uid, presence: true, uniqueness: { case_sensitive: true }
	validates :widget_position, presence: true
	validates :widget_position_id, presence: true

	delegate :user_id, to: :promotion

	def self.not_exists?(id)
			self.find(id)
			false
		rescue
			true
	end

	protected
	def generate_uid
		if self.uid.nil? || self.uid == ""
			self.uid = loop do
				uid = SecureRandom.urlsafe_base64(nil, false)
				break uid unless Merchant.where(uid: uid).exists?
			end
		end
	end

	def self.merchant_valid?(merchant_id)
		if merchant_id == nil
			false
		elsif merchant_id == ""
			false
		elsif self.find_by_uid(merchant_id) == nil
			false
		else
			true
		end
	end

end

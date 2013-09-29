class Merchant < ActiveRecord::Base
	include NotDeleteable
	versioned
	
	has_and_belongs_to_many :users

  	attr_accessible :name, :user_ids, :website, :button_id, :logo_link, :uid, :deleted

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :website, url: true
    validates :uid, presence: true, uniqueness: { case_sensitive: true }

  	has_many :promotions, dependent: :destroy
  	has_many :serves, through: :promotions
    belongs_to :button
  	#has_many :shares, through: :serves
    #has_many :sales, through: :shares

  	delegate :user_id, to: :promotion

    before_validation :generate_uid

    validates :button, presence: true
    validates :button_id, presence: true


  def self.not_exists?(id)
      self.find(id)
      false
    rescue
      true
  end

  protected
  def generate_uid
    self.uid = loop do
      uid = SecureRandom.urlsafe_base64(nil, false)
      break uid unless Merchant.where(uid: uid).exists?
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

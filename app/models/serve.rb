class Serve < ActiveRecord::Base
	include SecureRandom
  include NotDeleteable
	versioned

	attr_accessible :promotion_id, :email, :referring_share_id, :viewed, :session_id, :current_cause_id, :id

  belongs_to :promotion, counter_cache: true
  belongs_to :share, foreign_key: "referring_share_id"
  belongs_to :cause
  has_many :shares

	validates :promotion, presence: true
	validates :promotion_id, presence: true

  after_validation :replace_nils, :get_current_cause

	after_commit :create_shares, on: :create

  before_save :get_session_id

  def get_current_cause
    if self.current_cause_id.nil?
      self.current_cause_id = Promotion.find(self.promotion_id).cause_id
    end
  end

  def get_session_id
    if self.session_id.nil?
      self.session_id = Serve.new_session_id
    end
  end

  def self.new_session_id
    session_id = SecureRandom.hex(8)
    return session_id
  end

  def self.not_exists?(id)
  		self.find(id)
  		false
		rescue
  		true
	end

  def self.session_valid?(session_id,merchant)
    if session_id == nil
      false
    elsif session_id.length != 16
      false
    elsif self.find_by_session_id(session_id) == nil
      false
    elsif
      self.find_by_session_id(session_id).promotion.merchant != merchant
        false
    else
      true
    end
  end


	def create_shares
	Share.create_shares(self)
	end

  private
  def replace_nils
    if self.viewed.nil?
      self.viewed = false
    end
  end


end

class Serve < ActiveRecord::Base
	include SecureRandom
  include NotDeleteable
	versioned

	attr_accessible :promotion_id, :email, :referring_share_id, :viewed, :session_id, :current_cause_id, :id

  belongs_to :promotion, counter_cache: true
  belongs_to :share, foreign_key: "referring_share_id"
  belongs_to :cause, foreign_key: "current_cause_id"
  has_many :shares

	validates :promotion, presence: true
	validates :promotion_id, presence: true

  after_validation :replace_nils, :get_current_cause

	after_commit :create_all_shares, on: :create

  before_save :get_session_id

  def self.cause_changed?(serve,new_cause_uid)
    # check to see if a cause was passed in (non-nil) and if it is different from
    # the current cause value.
    case
      # check to see if both the old current cause and the new cause are nil or blank
      when (serve.current_cause_id.nil? or serve.current_cause_id == "") && (new_cause_uid.nil? or new_cause_uid == "")
        @cause_changed = false
        @cause = serve.current_cause_id
      # check to see if the new current cause is a valid cause
      when !Cause.cause_valid?(new_cause_uid)
        @cause_changed = false
        @cause = serve.current_cause_id
      # check to see if the new current cause is the same as the old current cause
      when serve.cause.uid == new_cause_uid 
        @cause_changed = false
        @cause = serve.current_cause_id
      # since both are not blank or nil and they are not the same, they must be different
      else
        @cause_changed = true
        @cause = Cause.where("uid = ?", new_cause_uid).first.id
    end
    return {cause_changed: @cause_changed, cause: @cause}
  end

  def self.email_changed?(serve,new_email)
    # Check to see if a new email was passed in and if it is different than the email 
    # in the serve record.  If it is different, set the email_changed flag to 
    # true and set the email variable to the new email address.
    case
        # check to see if both the old email and the new email are nil or blank
        when (serve.email.nil? or serve.email == "") && (new_email.nil? or new_email == "")
            @email_changed = false
            @email = serve.email
        # check to see if the new email is the same as the old email
        when serve.email == new_email #params[:email]
            @email_changed = false
            @email = serve.email
        # since both are not blank or nil and they are not the same, they must be different
        else
            @email_changed = true
            @email = new_email
    end
    return {email_changed: @email_changed, email: @email}
  end

  def self.post_to_channel(serve,channel)
    # get the share associated with this serve and channel_id, making sure to only
    # get the not confirmed share as there may be multiple confirmed shares but should
    # only be one not confirmed share per channel per serve
    @share = serve.shares.where("channel_id = ? and confirmed = ?",channel.id,false).first
    # now, mark this share as confirmed
    @share.update_attributes(confirmed: true, cause_id: serve.current_cause_id)
    # now, get a new share for this channel
    # Share.create_share(serve,channel)
  end

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
    loop do
      session_id = SecureRandom.urlsafe_base64()
      break session_id unless Serve.where(session_id: session_id).exists?
    end
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
    elsif session_id == ""
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

  private
	def create_all_shares
	Share.create_all_shares(self)
	end

  private
  def replace_nils
    if self.viewed.nil?
      self.viewed = false
    end
  end


end

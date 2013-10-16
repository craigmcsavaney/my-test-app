class Serve < ActiveRecord::Base
	include SecureRandom
  include NotDeleteable
	versioned

	attr_accessible :promotion_id, :email, :referring_share_id, :viewed, :session_id, :current_cause_id, :id, :user_id

  belongs_to :promotion, counter_cache: true
  belongs_to :share, foreign_key: "referring_share_id"
  belongs_to :cause, foreign_key: "current_cause_id"
  belongs_to :user
  has_many :shares
  has_many :sales, through: :shares
  delegate :merchant, :to => :promotion, :allow_nil => true

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

  def self.user_changed?(serve,new_email)
    # Check to see if an email was passed in and if it is different than the email 
    # associated with the user in the current serve record.  If it is different, set the 
    # user_changed flag to true and set the user_id variable to the new user_id.
    case
        # check to see if both the old user and the new user are nil or blank
        when (serve.user.nil? or serve.user.email == "") && (new_email.nil? or new_email == "")
            @user_changed = false
            @user_id = nil
            @type = nil
        # check to see if the new user is the same as the old user
        when !serve.user.nil? && serve.user.email == new_email #params[:email]
            @user_changed = false
            @user_id = serve.user_id
            @type = nil
        # check to see if there is a user associated with the current serve but the new email is blank or nil.  If this is the case, the new user should be nil.
        when !serve.user.nil? && (new_email.nil? or new_email == "")
            @user_changed = true
            @user_id = nil
            @type = "new"
        # since a new email is present and either there is no current user associated with the serve or it is a user with a different email than the new email, update the serve with the new user.  The GetUserID will create a new user for this email if needed or will find and return the user.id of the existing user for this email address.  The GetUserID method also returns type: "new" when it creates a new user.  This must be passed back to the API controller to set the user cookie to the new user email value.
        else
            @user_changed = true
            @user = User.GetUserID(new_email)
            @user_id = @user[:user_id]
            @type = @user[:type]
    end
    return {user_changed: @user_changed, user_id: @user_id, type: @type}
  end

  def self.post_to_channel(serve,channel)
    # get the share associated with this serve and channel_id, making sure to only
    # get the not confirmed share as there may be multiple confirmed shares but should
    # only be one not confirmed share per channel per serve
    @share = serve.shares.where("channel_id = ? and confirmed = ?",channel.id,false).first
    # now, mark this share as confirmed.  First, determine if this is a purchase share or not.  If it is, do not update the current_cause_id as the current cause will be added to the new purchase share that will be created later.  However, if this is a non-purchase share, update it with the current_cause_id.
    if channel.name == "Purchase"
        cause = ""
      else
        cause = serve.current_cause_id
    end
    @share.update_attributes(confirmed: true, cause_id: cause)
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

  def self.shared?(serve)
    serve.shares.where("confirmed = ? and channel_id <> ?", true, Channel.find_by_name("Purchase")).count > 0
  end

end

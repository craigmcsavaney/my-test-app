class Share < ActiveRecord::Base
	include NotDeleteable
	versioned

	attr_accessible :serve_id, :channel_id, :link_id, :confirmed, :cause_id, :deleted, :post_id
	
  # following retired with Awe.sm:
  # before_validation :get_awesome_path
  before_validation :generate_link_id

  belongs_to :serve, counter_cache: true
	belongs_to :channel
  belongs_to :cause
  has_many :serves
  has_many :sales
  delegate :promotion, :to => :serve, :allow_nil => true

	validates :serve, presence: true
	validates :channel, presence: true
	validates :link_id, presence: true, uniqueness: { case_sensitive: true }
	validates :serve_id, presence: true
	validates :channel_id, presence: true
	validate :selected_channel

  protected
  def generate_link_id
    if self.link_id.nil? || self.link_id == ""
      self.link_id = loop do
        link_id = SecureRandom.urlsafe_base64(6, false)
        break link_id unless Share.where(link_id: link_id).exists?
      end
    end
  end

  # Following Retired with Awe.sm:
  # private
  # def get_awesome_path
  #   if self.link_id == "" or self.link_id.nil?
  #     landing_page = Serve.find(self.serve_id).promotion.landing_page
  #     channel = Channel.find(self.channel_id).name
  #     self.link_id = Awesome.get_new_link_path(channel,landing_page)
  #   end
  # end

	private
  def selected_channel
    if !Promotion.find(Serve.find(self.serve_id).promotion_id).channel_ids.include?(self.channel_id)
      errors.add(:channel_id," :: The channel_id associated with this share is not one selected for the promotion")
    end
  end

  def self.not_exists?(id)
      self.find(id)
      false
    rescue
      true
  end

  def self.path_valid?(path)
    if path == nil
      false
    elsif path == ""
      false
    elsif self.find_by_link_id(path) == nil
      false
    else
      true
    end
  end

  def self.path_valid_for_this_serve?(path,serve)
    # the path is not valid for the given serve if the path is nil, the path is null (or blank), the path does not exist for any share, the serve associated with the path is different than the serve passed in, or the path is associated with an already confirmed share (meaning that a new share and new path have already been created).
    if path == nil
      false
    elsif path == ""
      false
    elsif self.find_by_link_id(path) == nil
      false
    elsif
      self.find_by_link_id(path).serve != serve
        false
    elsif 
      self.find_by_link_id(path).confirmed?
        false
    else
      true
    end
  end

  def self.path_valid_for_this_merchant?(path,merchant)
    # the path is not valid for the given merchant if the path is nil, the path is null (or blank), the path does not exist for any share, or the merchant associated with the path is different than the merchant passed in.
    if path == nil
      false
    elsif path == ""
      false
    elsif self.find_by_link_id(path) == nil
      false
    elsif
      self.find_by_link_id(path).serve.merchant != merchant
        false
    else
      true
    end
  end


  def self.create_all_shares(serve)
    # Create a new set of shares for a serve when a serve is created.
    serve.promotion.channels.each do |channel|
      self.create_share(serve,channel)
    end
  end

  def self.create_share(serve,channel)
    # create a share for the given serve and channel.

    # following not needed if using internally generated link_ids
    # landing_page = serve.promotion.landing_page
    # path = Awesome.get_new_link_path(channel.name,landing_page)

    # use this only for offline testing:
    # path = SecureRandom.urlsafe_base64(4)

    # following version used with Awe.sm only:
    # Share.create(serve_id: serve.id, channel_id: channel.id, link_id: path)

    # use this version with internally generated link_ids:
    Share.create(serve_id: serve.id, channel_id: channel.id)
  end

  def self.create_purchase_share(serve,channel,cause_id)
    # create a share for the given serve, channel and cause.

    # following not needed if using internally generated link_ids
    # landing_page = serve.promotion.landing_page
    # path = Awesome.get_new_link_path(channel.name,landing_page)

    # use this only for offline testing
    # path = SecureRandom.urlsafe_base64(4)  

    # following version used with Awe.sm only:
    # Share.create(serve_id: serve.id, channel_id: channel.id, link_id: path, cause_id: cause_id)

    # use this version with internally generated link_ids:
    Share.create(serve_id: serve.id, channel_id: channel.id, cause_id: cause_id)
  end

  # get_cause finds the cause id asociated with an input share by checking for the presence of a cause first at the share (which will be present if the share was confirmed), then at the serve (which could have been updated by a CB Widget viewer), then at the promotion level (which will be the merchant's preferred cause for this promotion.)  Note that this returns an id, not an object.
  def self.get_cause_id(share)
    if !share.cause.nil?
      cause_id = share.cause.id
    elsif !share.serve.current_cause_id.nil?
      cause_id = share.serve.current_cause_id
    else
      cause_id = share.serve.default_cause_id
    end
  end


end

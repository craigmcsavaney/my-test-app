class Share < ActiveRecord::Base
	include NotDeleteable
	versioned

	attr_accessible :serve_id, :channel_id, :link_id, :confirmed, :cause_id, :deleted
	
  before_validation :get_awesome_path

  belongs_to :serve, counter_cache: true
	belongs_to :channel
  belongs_to :cause
  has_many :serves

	validates :serve, presence: true
	validates :channel, presence: true
	validates :link_id, presence: true, uniqueness: { case_sensitive: true }
	validates :serve_id, presence: true
	validates :channel_id, presence: true
	validate :selected_channel

  private
  def get_awesome_path
    if self.link_id == "" or self.link_id.nil?
      landing_page = Serve.find(self.serve_id).promotion.landing_page
      channel = Channel.find(self.channel_id).name
      self.link_id = Awesome.get_new_link_path(channel,landing_page)
    end
  end

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

  def self.create_shares(serve)
    # If a Purchase share link does not exist for this serve_id, create one
#    if !serve.shares.where("channel_id = ?",Channel.find_by_name('Purchase').id).exists?
    landing_page = serve.promotion.landing_page
    channels = serve.promotion.channels.pluck(:name)
    channels.each do |channel|
      path = Awesome.get_new_link_path(channel,landing_page)
      Share.create(serve_id: serve.id, channel_id: Channel.find_by_name(channel).id, link_id: path)
    end
  end

end

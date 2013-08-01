class Share < ActiveRecord::Base
  include SecureRandom
	include NotDeleteable
	versioned

	attr_accessible :serve_id, :channel_id, :link_id, :confirmed, :cause_id
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

  def self.create_purchase_share(serve)
    # If a Purchase share link does not exist for this serve_id, create one
    if !serve.shares.where("channel_id = ?",Channel.find_by_name('Purchase').id).exists?
      Share.create(serve_id: serve.id, channel_id: Channel.find_by_name('Purchase').id, link_id: SecureRandom.base64(6))
    end
  end


end

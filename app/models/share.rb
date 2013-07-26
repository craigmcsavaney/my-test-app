class Share < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :serve_id, :channel_id, :link_id, :confirmed
  	belongs_to :serve
  	belongs_to :channel

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

end

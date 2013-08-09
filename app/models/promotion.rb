class Promotion < ActiveRecord::Base
  include NotDeleteable
    versioned

    attr_accessible :content, :end_date, :start_date, :name, :merchant_id, :channel_ids, :type_id, :cause_id, :merchant_pct, :supporter_pct, :buyer_pct, :landing_page, :uid, :priority, :disabled, :banner, :fb_msg, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, :disable_msg_editing, :tw_msg, :pin_msg, :pin_image_url, :pin_def_board, :pin_thumb_url, :li_msg, :deleted

    belongs_to :merchant, counter_cache: true
    has_and_belongs_to_many :channels,
      before_add: :habtm_update_uid,
      before_remove: :habtm_update_uid
    belongs_to :cause
    has_many :serves
    has_many :shares, through: :serves

    before_validation :replace_nils, :get_landing_page, :ensure_channel_attributes_present

    validates :merchant_id, presence: true
    validates :merchant, :presence => true
    validates :name, presence: true
    validates :cause, :presence => {message: ":: Please pick your default preferred cause for this promotion"} #, :unless => lambda { self.merchant_pct == 0 }
    validates :merchant_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
    validates :supporter_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
    validates :buyer_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100} 
    validates :landing_page, url: true
    validates :priority, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100} 
    validates :fb_link_label, presence: true
    validates :fb_caption, presence: true
    validates :fb_redirect_url, presence: true
    validates :fb_thumb_url, presence: true
    validate :channel_ids, :channel_count, on: :update
    validate :excessive_contribution, :missing_contribution, :prevent_deletion_of_viewed_promotions

    after_validation :check_for_disallowed_updates_to_served_promotions, :get_banners, :replace_nils
    before_update :check_content_change
    before_save :check_content_change
    after_commit :ensure_purchase_channel_enabled, :if => :persisted?

    private
    def ensure_channel_attributes_present
      if self.fb_link_label == ""
        self.fb_link_label = Setting.first.fb_link_label
      end
      if self.fb_caption == ""
        self.fb_caption = Setting.first.fb_caption
      end
      if self.fb_redirect_url == ""
        self.fb_redirect_url = Setting.first.fb_redirect_url
      end
      if self.fb_thumb_url == ""
        self.fb_thumb_url = Setting.first.fb_thumb_url
      end
      if self.tw_msg == ""
        self.tw_msg = Setting.first.tw_msg
      end
      if self.pin_msg == ""
        self.pin_msg = Setting.first.pin_msg
      end
      if self.pin_image_url == ""
        self.pin_image_url = Setting.first.pin_image_url
      end
      if self.pin_def_board == ""
        self.pin_def_board = Setting.first.pin_def_board
      end
      if self.pin_thumb_url == ""
        self.pin_thumb_url = Setting.first.pin_thumb_url
      end
      if self.li_msg == ""
        self.li_msg = Setting.first.li_msg
      end
    end

    private
    def get_landing_page
      if self.landing_page == ""
        self.landing_page = Merchant.find(self.merchant).website
      end
    end

    def ensure_purchase_channel_enabled
      if !self.channels.where("name = ?", "Purchase").exists?
        channels = self.channels
        purchase = Channel.find_by_name('Purchase')
        channels << purchase
      end
    end

    def get_banners
        self.banner = Banner.get_banner(self)
    end

    def check_for_disallowed_updates_to_served_promotions
      if self.serves.where("viewed = ?", true).any? and (self.name_changed? || self.merchant_id_changed? || self.content_changed? || self.merchant_pct_changed? || self.supporter_pct_changed? || self.buyer_pct_changed? || self.cause_id_changed?)
        self.name = self.name_was
        self.merchant_id = self.merchant_id_was
        self.content = self.content_was
        self.merchant_pct = self.merchant_pct_was
        self.supporter_pct = self.supporter_pct_was
        self.buyer_pct = self.buyer_pct_was
        self.cause_id = self.cause_id_was
      end
    end

    def check_content_change
      if self.start_date_changed? || self.end_date_changed? || self.name_changed? || self.merchant_id_changed? || self.content_changed? || self.merchant_pct_changed? || self.supporter_pct_changed? || self.buyer_pct_changed? || self.cause_id_changed?
        update_uid
      end
    end
    # For some reason, a single parameter is required for methods called from
    # association callbacks, which is why this method is called from the channels 
    # association callbacks instead of calling update_uid directly.
    def habtm_update_uid(promotion)
        update_uid
    end

    def update_uid
        self.uid = Time.now.utc.to_f
    end

    amoeba do
      enable
      exclude_field :serves
      prepend :name => "Copy of "
    end

    private
    def prevent_deletion_of_viewed_promotions
      if self.serves.where("viewed = ?", true).any? && self.deleted_changed?
        errors.add(:promotion_already_viewed, " :: You cannot delete a promotion that has been viewed by website guests.  Instead, consider disabling and hiding the promotion.")
      end
    end

    private
    def channel_count
      if self.supporter_pct > 0 and self.channels.count < 2
        errors.add(:channel_id," :: Because you are offering an incentive to visitors who share this promotion with their friends, you must choose at least one sharing channel for this promotion")
      end
    end

    private
    def excessive_contribution
      if self.merchant_pct + self.supporter_pct + self.buyer_pct > 100
        if self.merchant_pct > 0
          @a = :merchant_pct
        elsif self.supporter_pct > 0
          @a = :supporter_pct
        else
          @a = :buyer_pct
        end
        errors.add(@a," :: The sum of your contribution percentages exceeds 100%")
      end
    end

    private
    def missing_contribution
      if self.merchant_pct + self.supporter_pct + self.buyer_pct == 0
        errors.add(:supporter_pct," :: Your total contribution percentage must be greater than zero")
      end
    end

    private
    def replace_nils
      if self.merchant_pct.nil?
        self.merchant_pct = 0
      end
      if self.supporter_pct.nil?
        self.supporter_pct = 0
      end
      if self.buyer_pct.nil?
        self.buyer_pct = 0
      end
      if self.priority.nil?
        self.priority = 0
      end
    end

end

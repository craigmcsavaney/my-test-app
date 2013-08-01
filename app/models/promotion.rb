class Promotion < ActiveRecord::Base
  include NotDeleteable
    versioned

    attr_accessible :content, :end_date, :start_date, :name, :merchant_id, :channel_ids, :type_id, :cause_id, :merchant_pct, :supporter_pct, :buyer_pct, :landing_page, :uid, :priority, :disabled, :p_banner_1

    belongs_to :merchant #, counter_cache: true
    has_and_belongs_to_many :channels,
      before_add: :habtm_update_uid,
      before_remove: :habtm_update_uid
    belongs_to :cause
    has_many :serves
    has_many :shares, through: :serves

    before_validation :replace_nils

    validates :merchant_id, presence: true
    validates :merchant, :presence => true
    validates :name, presence: true
    validates :cause, :presence => {message: ":: Please pick a cause for your merchant-directed contribution"}, :unless => lambda { self.merchant_pct == 0 }
    validates :merchant_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
    validates :supporter_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
    validates :buyer_pct, :presence => true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100} 
    validate :excessive_contribution, :missing_contribution
    validates :landing_page, url: true
    validates :priority, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100} 
    validate :channel_ids, :channel_count, on: :update

    after_validation :check_for_disallowed_updates_to_served_promotions, :get_banners, :replace_nils
    before_update :check_content_change
    before_save :check_content_change
    after_commit :ensure_purchase_channel_enabled, :if => :persisted?

    def ensure_purchase_channel_enabled
      if !self.channels.where("name = ?", "Purchase").exists?
        channels = self.channels
        purchase = Channel.find_by_name('Purchase')
        channels << purchase
      end
    end

    def get_banners
        self.p_banner_1 = Banner.get_banner(self)
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

    def destroy
      if self.serves.where("viewed = ?", true).any?
        errors.add(:name, "You cannot delete a promotion that has been served to website guests.  Consider disabling and hiding the promotion.") unless self.serves.count == 0
        false
        else
          super
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

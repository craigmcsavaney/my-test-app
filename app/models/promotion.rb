class Promotion < ActiveRecord::Base
  include NotDeleteable
    versioned

    attr_accessible :description, :end_date, :start_date, :name, :merchant_id, :channel_ids, :type_id, :cause_id, :merchant_pct, :supporter_pct, :buyer_pct, :landing_page, :uid, :priority, :disabled, :banner, :banner_template, :facebook_msg, :facebook_msg_template, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, :disable_msg_editing, :twitter_msg, :twitter_msg_template, :pinterest_msg, :pinterest_msg_template, :pin_image_url, :pin_def_board, :pin_thumb_url, :linkedin_msg, :linkedin_msg_template, :deleted, :email_subject, :email_subject_template, :email_body, :email_body_template, :googleplus_msg, :googleplus_msg_template, :button_id, :widget_position_id, :fg_uuid, :cause_type, :event_id, :event_uid

    attr_accessor :fg_uuid, :cause_type, :event_uid

    belongs_to :merchant, counter_cache: true
    has_and_belongs_to_many :channels,
      before_add: :habtm_update_uid,
      before_remove: :habtm_update_uid
    belongs_to :cause
    belongs_to :button
    belongs_to :widget_position
    has_many :serves
    has_many :shares, through: :serves
    belongs_to :event

    before_validation :replace_nils, :get_landing_page, :get_button_id, :get_widget_position_id, :ensure_channel_attributes_present, :get_cause_and_event, :set_blank_accessors

    validates :cause_type, presence: true # allowable values are 'single' and 'event'
    validates :merchant_id, presence: true
    validates :merchant, :presence => true
    validates :button_id, presence: true
    validates :widget_position_id, presence: true
    validates :widget_position, presence: true
    validates :button, :presence => {message: ":: Please pick your button style for this promotion"}
    validates :name, presence: true
    validates :cause, :presence => {message: ":: Please pick your default preferred cause for this promotion.  If you already picked one, please try picking another one as there seems to be a problem."} #, :unless => lambda { self.merchant_pct == 0 }
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
    validate :excessive_contribution, :missing_contribution, :prevent_deletion_of_viewed_promotions, :mismatched_cause_type_selection

    after_validation :check_for_disallowed_updates_to_served_promotions, :get_templates, :replace_nils, :replace_variables, :synchronize_cause_and_event
    before_update :check_content_change
    before_save :check_content_change
    after_commit :ensure_purchase_channel_enabled, :if => :persisted?

    private
    def synchronize_cause_and_event
      # Check to see if the cause being saved is a single cause and if it is, ensure that there is no event associated with this promotion.  Because this is called after validation, we're assured that there will be a cause
      if self.cause.type == "Single"
        self.event_id = nil
      end
    end

    private
    def set_blank_accessors
      # If a promotion record is updated and there are no changes to the cause_id and the cause_type is blank and the cause exists, set the cause_type, fg_uuid, and event_uid to thier proper values
      if self.cause_type.nil? || self.cause_type == ""
        if !self.cause_id_changed? && !self.cause.nil? && !self.event_id_changed? 
          if self.cause.type == "Single"
            self.cause_type = "single"
            self.fg_uuid = self.cause.fg_uuid
          elsif self.cause.type == "Group"
            self.cause_type = "event"
            self.event_uid = self.event.uid
          end
        end
      end
    end

    private
    def mismatched_cause_type_selection
      if (self.cause_type == "single" && (self.fg_uuid.nil? || self.fg_uuid == "")) || (self.cause_type == "event" && (self.event_uid.nil? || self.event_uid == ""))
        errors.add(:cause_id," :: Please select a cause or event, or make sure the radio button reflects your current selection")
      end
    end

    private
    def get_cause_and_event
      # Every time a promotion is saved or updated, a cause_type of "single" or "event" must be provided, along with either a fg_uuid value (for single causes) or an event_id value (for events), or both.  If the cause_type is "single" and we have an actual value for fg_uuid, we use the fg_uuid to get (or create) the new cause_id. If the cause_type is event and there is an event_id submitted, we use the group_id associated with the event.  There are two other error conditions that will be checked in validation, where the selected cause_type is not accompanied by an event_id or fg_uuid (as appropriate).  

      # using the three inputs event_uid, fg_uuid, and cause_type, determine the correct cause if possible.  When not possible, later validations will raise the appropriate error.  Here are the possible cases:
      # 1.  event_uid and fg_uuid both blank, (cause_type either single, event, or blank): make no change to the cause_id and event_id.  The method set_blank_accessors will fill in blank values for event_uid and fg_uuid if cause and event already exist, and an error will be raised on validation if cause_id is blank.
      # 2.  cause_type is single or event, and there is a corresponding value for fg_uuid or event_uid.  THis case is handled below.
      # 3.  cause_type is single or event, but there is no corresponding value for fg_uuid or event_uid (but the other value is present - otherwise this would be case 1).  This is a wierd case because the other value that is present could be different from the initial value associated with this record, indicating that the user opened the promotion, changed the value, then checked the radio button for the other cause_type despite the fact that it was blank.  In the web app, this will result in an error raised from the mismatched_cause_type_selection validation, but in the widget this must be caught and prevented.
      if self.cause_type == "single" && !self.fg_uuid.nil? && self.fg_uuid != ""
        self.cause_id = Cause.get_cause_id(self.fg_uuid)
      end
      if self.cause_type == "event" && !self.event_uid.nil? && self.event_uid != ""
        if !Event.find_by_uid(self.event_uid).nil?
          # this will fail if an invalid event_uid was passed in, in which case neither the event_id nor the cause_id will be updated.  If the previous values were valid, the update will succeed, but if they are blank the update will fail on validation.
          self.event_id = Event.find_by_uid(self.event_uid).id
          self.cause_id = self.event.group.id
        end
      end

    end

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
      if self.pin_image_url == ""
        self.pin_image_url = Setting.first.pin_image_url
      end
      if self.pin_def_board == ""
        self.pin_def_board = Setting.first.pin_def_board
      end
      if self.pin_thumb_url == ""
        self.pin_thumb_url = Setting.first.pin_thumb_url
      end
    end

    private
    def get_landing_page
      if self.landing_page == ""
        self.landing_page = self.merchant.website
      end
    end

    private
    def get_button_id
      if self.button_id == "" || self.button_id.nil? || self.button_id == 0
        if !self.merchant.button_id.nil?
          self.button_id = self.merchant.button_id
        end
      end
    end

    private
    def get_widget_position_id
      if self.widget_position_id == "" || self.widget_position_id.nil? || self.widget_position_id == 0
        if !self.merchant.widget_position_id.nil?
            self.widget_position_id = self.merchant.widget_position_id
          else
            self.widget_position_id = WidgetPosition.where(name:"right-center").first.id
        end
      end
    end

    def ensure_purchase_channel_enabled
      if !self.channels.where("name = ?", "Purchase").exists?
        channels = self.channels
        purchase = Channel.find_by_name('Purchase')
        channels << purchase
      end
    end

    def get_templates
      if self.banner_template == "" || self.supporter_pct_changed? || self.buyer_pct_changed? || self.merchant_pct_changed?
        self.banner_template = Template.get_banner_template(self)
      end
      if self.facebook_msg_template == "" || self.supporter_pct_changed? || self.buyer_pct_changed? || self.merchant_pct_changed?
        self.facebook_msg_template = Template.get_facebook_msg_template(self)
      end
      if self.twitter_msg_template == ""
        self.twitter_msg_template = Setting.first.twitter_msg_template
      end
      if self.linkedin_msg_template == ""
        self.linkedin_msg_template = Setting.first.linkedin_msg_template
      end
      if self.pinterest_msg_template == ""
        self.pinterest_msg_template = Setting.first.pinterest_msg_template
      end
      if self.googleplus_msg_template == ""
        self.googleplus_msg_template = Setting.first.googleplus_msg_template
      end
      if self.email_subject_template == ""
        self.email_subject_template = Setting.first.email_subject_template
      end
      if self.email_body_template == ""
        self.email_body_template = Setting.first.email_body_template
      end
    end

    def replace_variables
      variables_changed = self.supporter_pct_changed? || self.buyer_pct_changed? || self.merchant_id_changed? || self.cause_id_changed? || self.merchant_pct_changed?
      if self.banner_template_changed? or variables_changed
        self.banner = Template.replace_template_variables(self.banner_template,self)
      end
      if self.facebook_msg_template_changed? || variables_changed
        self.facebook_msg = Template.replace_template_variables(self.facebook_msg_template,self)
      end
      if self.twitter_msg_template_changed? || variables_changed
        self.twitter_msg = Template.replace_template_variables(self.twitter_msg_template,self)
      end
      if self.linkedin_msg_template_changed? || variables_changed
        self.linkedin_msg = Template.replace_template_variables(self.linkedin_msg_template,self)
      end
      if self.pinterest_msg_template_changed? || variables_changed
        self.pinterest_msg = Template.replace_template_variables(self.pinterest_msg_template,self)
      end
      if self.googleplus_msg_template_changed? || variables_changed
        self.googleplus_msg = Template.replace_template_variables(self.googleplus_msg_template,self)
      end
      if self.email_subject_template_changed? || variables_changed
        self.email_subject = Template.replace_template_variables(self.email_subject_template,self)
      end
      if self.email_body_template_changed? || variables_changed
        self.email_body = Template.replace_template_variables(self.email_body_template,self)
      end
    end

    def check_for_disallowed_updates_to_served_promotions
      if self.serves.where("viewed = ?", true).any? and (self.name_changed? || self.merchant_id_changed? || self.merchant_pct_changed? || self.supporter_pct_changed? || self.buyer_pct_changed? || self.cause_id_changed?)
        self.name = self.name_was
        self.merchant_id = self.merchant_id_was
        self.merchant_pct = self.merchant_pct_was
        self.supporter_pct = self.supporter_pct_was
        self.buyer_pct = self.buyer_pct_was
        self.cause_id = self.cause_id_was
      end
    end

    def check_content_change
      if self.start_date_changed? || self.end_date_changed? || self.name_changed? || self.merchant_id_changed? || self.merchant_pct_changed? || self.supporter_pct_changed? || self.buyer_pct_changed? || self.cause_id_changed?
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
      exclude_field :shares
      exclude_field :serves_count
      prepend :name => "Copy of "

      customize(lambda { |original_promotion,new_promotion|
        if original_promotion.cause.type == "Single"
          # necessary to satisfy the cause_type presence validation:
          new_promotion.cause_type = "single" 
          # necessary to satisfy the mismatched_cause_type_selection validator:
          new_promotion.fg_uuid = original_promotion.cause.fg_uuid
        elsif original_promotion.cause.type == "Group"
          # necessary to satisfy the cause_type presence validation:
          new_promotion.cause_type = "event"
          # necessary to satisfy the mismatched_cause_type_selection validator
          new_promotion.event_uid = original_promotion.event.uid
        end
      })
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

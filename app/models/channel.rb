class Channel < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :name, :awesm_id, :description, :deleted, :visible, :active, :url_prefix, :font_awesome_icon_name, :display_order

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :awesm_id, presence: true
    validates :display_order, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1000} 

  	has_and_belongs_to_many :promotions, join_table: :channels_promotions
  	has_many :shares
end

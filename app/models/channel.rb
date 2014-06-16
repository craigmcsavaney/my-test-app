class Channel < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :name, :awesm_id, :description, :deleted, :visible, :active, :url_prefix
  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :awesm_id, presence: true

  	has_and_belongs_to_many :promotions, join_table: :channels_promotions
  	has_many :shares
end

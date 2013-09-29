class Button < ActiveRecord::Base
	include NotDeleteable
    versioned

   	attr_accessible :name, :description, :button_type_id, :display_order, :filename, :deleted, :html

   	belongs_to :button_type
   	has_many :merchants
   	has_many :promotions

   	validates :button_type, presence: true
	validates :button_type_id, presence: true
	validates :display_order, presence: true

end

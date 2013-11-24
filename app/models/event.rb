class Event < ActiveRecord::Base
	include NotDeleteable
    versioned

  	attr_accessible :name, :description, :order, :deleted, :event_date, :start_date, :end_date, :group_id

  	belongs_to :group

  	validates :name, presence: true, uniqueness: { case_sensitive: false }
  	validates :group_id, presence: true
  	validates :event_date, presence: true
  	validates :start_date, presence: true
  	validates :end_date, presence: true

end

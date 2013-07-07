class Promotion < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :name, :merchant_id, :channel_ids
  validates :merchant_id, presence: true
  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :merchant_id, :case_sensitive => false

  belongs_to :merchant
  has_and_belongs_to_many :channels

  validates :merchant, :presence => true
end

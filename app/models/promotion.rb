class Promotion < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :name, :merchant_id
  validates :merchant_id, presence: true
  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :merchant_id, :case_sensitive => false

  belongs_to :merchant

  validates :merchant, :presence => true
end

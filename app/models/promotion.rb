class Promotion < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :name, :merchant_id
  validates :merchant_id, presence: true
  validates :name, presence: true

  belongs_to :merchant

  validates :merchant, :presence => true
end

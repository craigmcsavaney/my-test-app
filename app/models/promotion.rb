class Promotion < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :name
  validates :merchant_id, presence: true
  validates :name, presence: true

  belongs_to :merchant
end

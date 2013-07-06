class Channel < ActiveRecord::Base
  attr_accessible :name, :awesm_id, :description
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :awesm_id, presence: true
end

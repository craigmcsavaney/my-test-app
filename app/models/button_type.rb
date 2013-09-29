class ButtonType < ActiveRecord::Base
	include NotDeleteable
    versioned
  	
  	attr_accessible :name, :description

  	has_many :buttons

	validates :name, presence: true, uniqueness: { case_sensitive: false }


end

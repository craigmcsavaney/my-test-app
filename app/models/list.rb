class List < ActiveRecord::Base
	include NotDeleteable
    versioned

  	attr_accessible :type
  	
end

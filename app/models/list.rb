class List < ActiveRecord::Base
	include NotDeleteable
    versioned
 	
end

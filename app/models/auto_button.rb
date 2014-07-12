class AutoButton < List
	include NotDeleteable
    versioned

  	attr_accessible :name, :description, :order, :deleted

  	has_many :merchants

end

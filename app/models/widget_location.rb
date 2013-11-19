class WidgetLocation < List
	include NotDeleteable
    versioned

  	attr_accessible :name, :description, :order, :deleted

  	has_many :promotions
end

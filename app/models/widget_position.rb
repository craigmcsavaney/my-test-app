class WidgetPosition < List
	include NotDeleteable
    versioned

  	attr_accessible :name, :description, :order, :deleted

  	has_many :promotions
  	has_many :merchants
end

class Single < Cause
	include NotDeleteable
    versioned

	attr_accessible :name, :user_ids, :group_ids, :uid

end
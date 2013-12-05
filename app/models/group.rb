class Group < Cause
	include NotDeleteable
    versioned

	attr_accessible :name, :user_ids, :cause_ids, :uid

	has_and_belongs_to_many :causes
	has_many :events
end
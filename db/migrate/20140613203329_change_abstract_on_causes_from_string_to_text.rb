class ChangeAbstractOnCausesFromStringToText < ActiveRecord::Migration
  	def up
      	# simple and straightforward
      	# note that text field can't have a default value
        change_column :causes, :abstract, :string, default: nil
  		change_column :causes, :abstract, :text
    end

    def down
        # create a temporary column to hold the truncated values
        # we'll rename this later to the original column name
        add_column :causes, :temp_abstract, :string, default: ""

        # use #find_each to load only part of the table into memory
        Cause.find_each do |cause|
            temp_abstract = cause.abstract
            # test if the new value will fit into the truncated field
            if cause.abstract.length > 255
                # shorten it to just 255 characters
                temp_abstract = cause.abstract[0,254]
            end
            # use #update_column because it skips validations AND callbacks
            cause.update_column(:temp_abstract, temp_abstract)
        end

        # delete the old column since we have all the data safe in the
        # temp_abstract
        remove_column :causes, :abstract

        # rename the temp_column to our original column name
        rename_column :causes, :temp_abstract, :abstract
    end
end

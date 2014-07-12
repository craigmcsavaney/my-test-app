module NotDeleteable
  def destroy
    unless self.respond_to? :deleted
      raise MissingMigrationException
    end

    self.update_attributes( :deleted => true )
#    self.update_attribute :deleted, true  this is the original line
  end

  def delete
    self.destroy
  end

  def self.included(base)
    base.class_eval do
      default_scope { where( :deleted => false ) }
    end
  end
end



class MissingMigrationException < Exception
  def message
    "Model is lacking the deleted boolean field for NotDeleteable to work"
  end
end
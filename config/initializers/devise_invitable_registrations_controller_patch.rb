DeviseInvitable::RegistrationsController.class_eval do
	class DeviseInvitable::RegistrationsController < Devise::RegistrationsController
	  protected

	  def build_resource(*args)
	    hash = args.pop || resource_params || {}
	    if hash[:email]
	      self.resource = resource_class.where(:email => hash[:email], :encrypted_password => '').first
	      if self.resource
	        self.resource.attributes = hash
	        self.resource.accept_invitation
	      end
	    end
	    # following line rem'd by Craig and replaced by the line below to fix the registration confirmation 
	    # problem that displayed "Email can't be blank, password can't be blank" validation errors
	    # self.resource ||= super
	    self.resource ||= super(hash)
	  end
	end
end



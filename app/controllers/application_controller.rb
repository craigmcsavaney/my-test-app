class ApplicationController < ActionController::Base
	before_filter :set_return_page
	# following addition of "with: :null_session" might fix the problem Devise has with
	# protect_from_forgery.  If not, will need to modify other controllers to skip verification
	# of the authenticity token.
  	protect_from_forgery with: :null_session

  	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  	end

	def after_sign_in_path_for(resource)
	    #(session[:return_page].nil?) ? "/" : session[:return_page]
	    donations_path
	end

	def after_sign_out_path_for(resource_or_scope)
	  	#request.referrer
	  	"http://www.causebutton.com"
	end

  	protected
	def set_return_page
		unless request.referer.nil? || request.referer.include?('/users/sign')
  			session[:return_page] = request.referer
		end
  	end	

end

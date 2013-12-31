class ApplicationController < ActionController::Base
	before_filter :set_return_page
  	protect_from_forgery

  	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  	end

	def after_sign_in_path_for(resource)
	    (session[:return_page].nil?) ? "/" : session[:return_page]
	end

  	protected
	def set_return_page
		unless request.referer.nil? || request.referer.include?('/users/sign')
  			session[:return_page] = request.referer
		end
  	end	

end

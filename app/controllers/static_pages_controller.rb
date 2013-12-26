class StaticPagesController < ApplicationController
	layout false, only: :home

  	def home
  	end

  	def help
  	end

  	def about
  	#TestMailer.welcome_email2.deliver
  	end

  	def contact
  	end
end

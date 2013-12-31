class StaticPagesController < ApplicationController
	layout false, only: :landing

  	def home
  	end

  	def help
  	end

  	def about
  	#TestMailer.welcome_email2.deliver
  	end

  	def contact
  	end

    def landing
    end
end

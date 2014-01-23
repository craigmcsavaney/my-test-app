class ContactMessagesController < ApplicationController

  def create
		@message = ContactMessage.new(params[:contact_message])
    if !@message.valid?
      flash[:failure] = "Oops - something's not right. Please try again."
    elsif !verify_recaptcha
      # this will raise the recaptcha api error, which gets translated in config/locales/en.yml
    else
      success = ContactMessage.post_contact_message(@message.first_name, @message.last_name, @message.phone, @message.email, @message.message)
      if success
        flash[:success] = "Thanks - we got your message and we'll get back to you shortly!"
        @message = ContactMessage.new
      else
        flash[:failure] = "Oops - something went wrong.  Please try again."
      end
    end
    redirect_to home_path(first_name: @message.first_name, last_name: @message.last_name, phone: @message.phone, email: @message.email, message: @message.message)
	end

end
class DonationMailer < ActionMailer::Base
	default from: 'craig@causebutton.com'
 
  def donation_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'http://causebutton.com/'
    mail(to: @email, subject: 'You caused another donation!')
  end

end
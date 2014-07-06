class DonationMailer < ActionMailer::Base
	# this is the same as the default from address config'd in application.rb.  Probably unnecessary.	
	default from: '\'CauseButton\' <craig@causebutton.com>'
 
  def donation_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'http://causebutton.com/'
    mail(to: @email, subject: 'You caused another donation!')
  end

end
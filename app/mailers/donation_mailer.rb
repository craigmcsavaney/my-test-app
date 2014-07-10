class DonationMailer < ActionMailer::Base
	# this is the same as the default from address config'd in application.rb.  Probably unnecessary.	
	default from: '\'CauseButton\' <craig@causebutton.com>'
 
  def donation_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'http://causebutton.com/'
    mail(to: @email, subject: 'You caused another donation!')
  end

  def merchant_sale_email(email,total,merchant_donation,supporter_donation,buyer_donation)
    @email = email
    @total = total
    @merchant_donation = merchant_donation
    @supporter_donation = supporter_donation
    @buyer_donation = buyer_donation
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Another CauseButton-generated Sale!')
  end

  def merchant_donation_supporter_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your sharing caused another donation!')
  end

  def merchant_donation_buyer_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your purchase caused another donation!')
  end

  def supporter_donation_supporter_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your sharing caused another donation!')
  end

  def supporter_donation_buyer_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your purchase caused another donation!')
  end

  def buyer_donation_supporter_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your sharing caused another donation!')
  end

  def buyer_donation_buyer_email(donation,email)
    @donation = donation
    @email = email
    @url  = 'https://app.causebutton.com/'
    mail(to: @email, subject: 'Your purchase caused another donation!')
  end

end
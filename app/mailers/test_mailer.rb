class TestMailer < ActionMailer::Base
	default from: 'craig@causebutton.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://causebutton.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end

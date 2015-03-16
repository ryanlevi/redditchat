class UserMailer < ActionMailer::Base
  default from: "domatio.app@gmail.com"

  def welcome_email(user)
    # sends an email to the user welcoming them to our website
    @user = user
    mail :to => user.name, :subject => "Welcome to RedditChat!", :body => "Congratulations, #{@user.name}, you've successfully registered at RedditChat."
  end

end
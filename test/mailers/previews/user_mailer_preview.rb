# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Remember restarting the server before visiting the site otherwise the path
  # cannot be recognised!
  def account_activation
    user = User.first
    # Note that a value (new token) is assigned to user.activation_token, this
    # is necessary because the account activation templates need an account 
    # activation token. (Because activation_token is a virtual attribute, the
    # user from the database doesn't have one.)
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end

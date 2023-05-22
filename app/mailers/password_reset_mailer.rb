class PasswordResetMailer < ApplicationMailer
  def reset_password_instructions(user)
    @user = user
    @reset_password_url = edit_user_password_url(reset_password_token: @user.reset_password_token)

    mail(to: @user.email, subject: 'Reset Your Password')
  end
end

class DigestMailer < ApplicationMailer
  def daily_digest(user, tasks)
    @user = user
    @tasks = tasks
    
    mail(
      to: user.email,
      subject: "Your Project Hub Daily Digest - #{Date.today}"
    )
  end
end

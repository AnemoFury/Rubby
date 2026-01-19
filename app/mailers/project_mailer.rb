class ProjectMailer < ApplicationMailer
  def task_updated(user, task, action)
    @user = user
    @task = task
    @action = action
    
    mail(
      to: user.email,
      subject: "Task Updated: #{task.title}"
    )
  end
end

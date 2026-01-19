class TaskNotificationJob < ApplicationJob
  queue_as :default

  def perform(task, action)
    task.assignees.each do |user|
      ProjectMailer.task_updated(user, task, action).deliver_later
    end
  end
end

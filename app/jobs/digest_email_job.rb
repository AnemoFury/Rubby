class DigestEmailJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      tasks = user.assigned_tasks.where("updated_at > ?", 24.hours.ago)
      
      next if tasks.empty?
      
      DigestMailer.daily_digest(user, tasks).deliver_later
    end
  end
end

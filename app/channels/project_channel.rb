class ProjectChannel < ApplicationCable::Channel
  def subscribed
    project = Project.find(params[:project_id])
    stream_for project
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def move_task(data)
    task = Task.find(data["task_id"])
    new_status = data["status"]
    
    task.move_to(new_status)
    
    broadcast_to_project(task.project, {
      action: "task_moved",
      task_id: task.id,
      status: task.status,
      timestamp: Time.current
    })
  end

  def assign_task(data)
    task = Task.find(data["task_id"])
    user = User.find(data["user_id"])
    
    task.assign_to(user)
    
    broadcast_to_project(task.project, {
      action: "task_assigned",
      task_id: task.id,
      user_id: user.id,
      timestamp: Time.current
    })
  end

  private

  def broadcast_to_project(project, message)
    ProjectChannel.broadcast_to(project, message)
  end
end

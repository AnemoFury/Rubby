class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: [:show, :update, :move, :destroy]

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      TaskNotificationJob.perform_later(@task, "created")
      render :create, formats: :turbo_stream
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      TaskNotificationJob.perform_later(@task, "updated")
      render :update, formats: :turbo_stream
    else
      render :edit
    end
  end

  def move
    new_status = params[:status]
    @task.move_to(new_status)

    render :update, formats: :turbo_stream
  end

  def assign
    @task = @project.tasks.find(params[:task_id])
    @user = User.find(params[:user_id])
    
    @task.assign_to(@user)
    
    render :update, formats: :turbo_stream
  end

  def destroy
    @task.destroy
    render :destroy, formats: :turbo_stream
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
    authorize @project
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority)
  end
end

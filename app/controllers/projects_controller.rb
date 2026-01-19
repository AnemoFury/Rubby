class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.active.recent
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
    @tasks = @project.tasks.by_status
    @task = Task.new
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    @project.owner = current_user

    if @project.save
      @project.add_member(current_user)
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  def archive
    @project = Project.find(params[:id])
    authorize @project
    @project.archive!
    redirect_to projects_url, notice: "Project archived."
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end

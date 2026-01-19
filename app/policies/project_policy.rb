class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def show?
    user.projects.include?(project) || project.members.include?(user)
  end

  def create?
    true
  end

  def update?
    user == project.owner || project.members.where(role: :admin).include?(user)
  end

  def destroy?
    user == project.owner
  end

  def archive?
    user == project.owner
  end

  def add_member?
    update?
  end

  def remove_member?
    update?
  end
end

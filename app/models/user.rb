class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :nullify
  has_many :task_assignments, dependent: :destroy
  has_many :tasks, through: :task_assignments

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def active_projects
    projects.active
  end

  def assigned_tasks
    tasks.where(task_assignments: { status: "active" })
  end
end

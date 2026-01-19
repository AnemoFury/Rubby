class TaskAssignment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :task_id, uniqueness: { scope: :user_id }

  broadcasts_to -> { task.project }, inserts_by: :prepend
  broadcasts :update

  enum :status, { active: 0, completed: 1, paused: 2 }
end

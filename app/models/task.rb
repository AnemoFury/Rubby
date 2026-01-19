class Task < ApplicationRecord
  belongs_to :project
  has_many :task_assignments, dependent: :destroy
  has_many :assignees, through: :task_assignments, source: :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :project_id, presence: true

  enum :status, { todo: 0, in_progress: 1, done: 2 }

  scope :active, -> { where(completed_at: nil) }
  scope :by_status, -> { order(status: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  broadcasts_to -> { project }, inserts_by: :prepend
  broadcasts :update

  def assign_to(user)
    task_assignments.find_or_create_by(user: user)
  end

  def unassign_from(user)
    task_assignments.find_by(user: user)&.destroy
  end

  def move_to(new_status)
    update(status: new_status)
    broadcast_update
  end

  def complete!
    update(status: :done, completed_at: Time.current)
  end

  def to_s
    title
  end
end

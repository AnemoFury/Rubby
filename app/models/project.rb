class Project < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :tasks, dependent: :destroy
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user
  has_many :task_assignments, through: :tasks
  has_many :assigned_users, through: :task_assignments, source: :user, distinct: true

  validates :name, presence: true
  validates :owner_id, presence: true

  scope :active, -> { where(archived_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  broadcasts_to :project_hub, inserts_by: :prepend

  def add_member(user)
    members << user unless members.include?(user)
  end

  def remove_member(user)
    members.delete(user)
  end

  def archive!
    update(archived_at: Time.current)
  end

  def to_s
    name
  end
end

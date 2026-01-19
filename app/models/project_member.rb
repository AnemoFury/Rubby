class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :project_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :project_id }

  enum :role, { member: 0, admin: 1 }
end

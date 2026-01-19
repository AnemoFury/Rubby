class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :author, class_name: "User"

  validates :body, presence: true
  validates :task_id, :author_id, presence: true

  broadcasts_to -> { task }, inserts_by: :prepend
  broadcasts :create
end

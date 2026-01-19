class CreateTaskAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :task_assignments do |t|
      t.references :task, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :task_assignments, [:task_id, :user_id], unique: true
  end
end

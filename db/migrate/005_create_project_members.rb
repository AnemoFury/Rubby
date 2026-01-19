class CreateProjectMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :project_members do |t|
      t.references :project, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :project_members, [:project_id, :user_id], unique: true
  end
end

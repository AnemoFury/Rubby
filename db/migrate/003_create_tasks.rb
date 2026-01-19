class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.references :project, foreign_key: true, null: false
      t.integer :status, default: 0
      t.string :priority, default: "Medium"
      t.datetime :completed_at

      t.timestamps
    end

    add_index :tasks, :status
    add_index :tasks, [:project_id, :status]
  end
end

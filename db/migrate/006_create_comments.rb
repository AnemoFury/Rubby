class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :task, foreign_key: true, null: false
      t.references :author, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end

    add_index :comments, [:task_id, :created_at]
  end
end

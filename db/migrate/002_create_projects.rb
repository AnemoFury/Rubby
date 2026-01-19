class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.references :owner, foreign_key: { to_table: :users }, null: false
      t.datetime :archived_at

      t.timestamps
    end

    add_index :projects, :name
  end
end

class CreateSplines < ActiveRecord::Migration[5.2]
  def change
    create_table :splines do |t|
      t.string :name, null: false
    end
    add_index :splines, :name, unique: true
  end
end

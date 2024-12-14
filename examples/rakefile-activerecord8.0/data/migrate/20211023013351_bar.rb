class Bar < ActiveRecord::Migration[7.0]
  def change
    create_table :bars do |t|
      t.string :name, null: false
    end
  end
end

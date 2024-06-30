ActiveRecord::Base.logger = nil

module Schema
  def self.load!
    ActiveRecord::Base.connection.instance_eval do
      drop_table :categories if table_exists? :categories
      create_table :categories do |t|
        t.string :name, null: false
      end

      drop_table :widgets if table_exists? :widgets
      create_table :widgets do |t|
        t.string :name, null: false
        t.integer :category_id
      end
      add_index :widgets, :category_id
    end
  end
end

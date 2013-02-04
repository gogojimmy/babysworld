class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      t.integer :original_price, :default => 0
      t.integer :price, :default => 0
      t.string :url, :null => false
      t.integer :user_id, :null => false
      t.string :status, :default => "waiting_for_review"
      t.boolean :is_public, :default => false

      t.timestamps
    end
    add_index :products, :name
    add_index :products, :user_id
    add_index :products, :status
    add_index :products, :is_public
  end
end

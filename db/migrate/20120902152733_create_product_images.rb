class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.string :image
      t.string :product_id

      t.timestamps
    end
    add_index :product_images, :product_id
  end
end

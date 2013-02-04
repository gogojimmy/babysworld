class CreateConsignments < ActiveRecord::Migration
  def change
    create_table :consignments do |t|
      t.integer :user_id
      t.string :name
      t.string :address
      t.string :phone
      t.string :status
      t.string :chinese_name
      t.integer :product_id
      t.string :attachment
      t.string :attachment_tmp
      t.boolean :attachment_processing

      t.timestamps
    end
    add_index :consignments, :user_id
    add_index :consignments, :product_id
  end
end

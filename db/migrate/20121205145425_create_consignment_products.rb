class CreateConsignmentProducts < ActiveRecord::Migration
  def change
    create_table :consignment_products do |t|
      t.string :name
      t.integer :consignment_id

      t.timestamps
    end
    add_index :consignment_products, :consignment_id
    remove_column :consignments, :name
  end
end

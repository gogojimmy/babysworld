class RemoveProductFromConsignment < ActiveRecord::Migration
  def change
    remove_column :consignments, :product_id
    add_column :consignment_products, :product_id, :integer
    add_column :consignments, :payed, :boolean
    add_index :consignment_products, :product_id
  end
end

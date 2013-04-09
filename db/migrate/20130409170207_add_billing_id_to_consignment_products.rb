class AddBillingIdToConsignmentProducts < ActiveRecord::Migration
  def change
    add_column :consignment_products, :billing_id, :integer
    add_index :consignment_products, :billing_id
  end
end

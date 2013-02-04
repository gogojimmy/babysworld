class AddBalanceToConsignment < ActiveRecord::Migration
  def change
    add_column :consignments, :balance, :integer, default: 0
  end
end

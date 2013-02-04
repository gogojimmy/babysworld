class AddAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :phone, :string
    add_column :users, :chinese_name, :string
  end
end

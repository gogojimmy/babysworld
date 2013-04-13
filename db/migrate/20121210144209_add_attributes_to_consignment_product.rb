#encoding: utf-8
class AddAttributesToConsignmentProduct < ActiveRecord::Migration
  def change
    add_column :consignment_products, :brand, :string
    add_column :consignment_products, :path, :string
    add_column :consignment_products, :warranty, :boolean, default: false
    add_column :consignment_products, :guarantee, :boolean, default: false
    add_column :consignment_products, :price, :integer, default: 0
    add_column :consignment_products, :how_new, :string
    add_column :consignment_products, :short_coming, :text
    add_column :consignment_products, :comment, :text
    add_column :consignment_products, :dealing_status, :string
    add_column :consignment_products, :attachment, :string
    add_column :consignment_products, :attachment_tmp, :string
    add_column :consignment_products, :attachment_processing, :boolean
    add_column :consignments, :argu_price, :boolean, default: false
    add_column :consignments, :allow_fix, :boolean, default: false
    add_column :consignments, :bank, :string
    add_column :consignments, :account, :string
    add_column :consignments, :bank_num, :string
    add_column :consignments, :account_num, :string
    add_column :users, :bank, :string
    add_column :users, :account, :string
    add_column :users, :bank_num, :string
    add_column :users, :account_num, :string
  end
end

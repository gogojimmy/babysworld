class AddAttributesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pattern, :text
    add_column :products, :notice, :text
  end
end

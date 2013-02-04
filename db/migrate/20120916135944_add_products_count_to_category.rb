class AddProductsCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :products_count, :integer
    remove_column :products, :is_public

    Category.reset_column_information
    Category.all.each do |c|
      c.update_attribute :products_count, c.products.available.length
    end
  end
end

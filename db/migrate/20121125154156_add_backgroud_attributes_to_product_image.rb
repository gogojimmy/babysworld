class AddBackgroudAttributesToProductImage < ActiveRecord::Migration
  def change
    add_column :product_images, :image_processing, :boolean
    add_column :product_images, :image_tmp, :string
    add_column :banners, :banner_processing, :boolean
    add_column :banners, :banner_tmp, :string
  end
end

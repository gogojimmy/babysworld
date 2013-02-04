class ProductImage < ActiveRecord::Base
  attr_accessible :image, :product_id
  belongs_to :product

  mount_uploader :image, ImageUploader
  process_in_background :image
  store_in_background :image

end

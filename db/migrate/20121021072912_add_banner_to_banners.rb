class AddBannerToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :banner, :string
  end
end

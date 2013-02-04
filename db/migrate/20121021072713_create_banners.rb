class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :url

      t.timestamps
    end
  end
end

class ChangeProductUrlToRutenNo < ActiveRecord::Migration
  def change
    rename_column :products, :url, :ruten_no
  end
end

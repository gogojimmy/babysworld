class AddValueCacheToUser < ActiveRecord::Migration
  def change
    add_column :users, :money_can_apply, :integer, default: 0
    add_column :users, :money_already_earned, :integer, default: 0
  end
end

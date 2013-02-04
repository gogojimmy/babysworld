class AddAgreeTermsToUser < ActiveRecord::Migration
  def change
    add_column :users, :terms, :boolean, default: true
    add_column :users, :marketing, :boolean, default: true
  end
end

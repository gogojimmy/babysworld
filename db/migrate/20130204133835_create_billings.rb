class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.integer :user_id
      t.boolean :done, default: false
      t.integer :amount

      t.timestamps
    end
    add_index :billings, :user_id
  end
end

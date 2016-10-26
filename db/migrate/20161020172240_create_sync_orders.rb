class CreateSyncOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :sync_orders do |t|
      t.string :user_id
      t.integer :user_type
      t.string :product_id
      t.string :service_id
      t.string :services_list
      t.integer :update_type
      t.string :update_description
      t.datetime :update_time
      t.datetime :effective_time
      t.datetime :expiry_time
      t.string :transaction_id
      t.string :order_key
      t.integer :mdspsubexpmode
      t.integer :object_type
      t.boolean :rent_success

      t.timestamps
    end
  end
end

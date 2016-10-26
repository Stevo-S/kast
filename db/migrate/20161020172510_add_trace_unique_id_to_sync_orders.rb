class AddTraceUniqueIdToSyncOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :sync_orders, :traceunique_id, :string
  end
end

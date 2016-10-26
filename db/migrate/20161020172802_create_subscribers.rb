class CreateSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.string :phone_number
      t.string :service_id
      t.boolean :active
      t.datetime :first_subscribed_at
      t.datetime :last_subscribed_at
      t.datetime :last_unsubscribed_at

      t.timestamps
    end
  end
end

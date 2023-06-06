class CreateSubscriptionRates < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_rates do |t|
      t.float :rate

      t.timestamps
    end
  end
end

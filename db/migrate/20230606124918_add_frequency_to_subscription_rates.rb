class AddFrequencyToSubscriptionRates < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_rates, :frequency, :string
  end
end

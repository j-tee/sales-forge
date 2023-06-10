class AddStoresToSubscriptionDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_discounts, :stores, :integer
  end
end

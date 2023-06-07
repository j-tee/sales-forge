class CreateSubscriptionTaxes < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_taxes do |t|
      t.float :rate
      t.string :name

      t.timestamps
    end
  end
end

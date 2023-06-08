class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.float :amount
      t.boolean :paid
      t.date :start_date
      t.date :end_date
      t.references :user, null: false, foreign_key: true
      t.references :subscription_discount, null: false, foreign_key: true
      t.references :subscription_rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end

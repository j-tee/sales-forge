class CreateStoreDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :store_discounts do |t|
      t.references :store, null: false, foreign_key: true
      t.references :discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end

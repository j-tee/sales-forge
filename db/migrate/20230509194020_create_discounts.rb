class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.string :name
      t.string :discount_type
      t.decimal :discount_value
      t.date :start_date
      t.date :end_date
      t.boolean :applicable
      t.decimal :percentage

      t.timestamps
    end
  end
end

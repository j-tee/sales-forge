class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.decimal :unit_price
      t.string :product_name
      t.decimal :unit_cost
      t.string :country
      t.string :manufacturer
      t.date :mnf_date
      t.date :exp_date
      t.integer :qty_in_stock
      t.references :category, null: false, foreign_key: true
      t.text :description
      t.string :supplier
      t.integer :qty_sold
      t.integer :total_expired
      t.integer :qty_stolen
      t.integer :qty_damaged
      t.integer :stock_id

      t.timestamps
    end
  end
end

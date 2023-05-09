class CreateProductDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :product_discounts do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end

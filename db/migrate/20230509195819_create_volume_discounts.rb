class CreateVolumeDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :volume_discounts do |t|
      t.string :name
      t.decimal :upper_limit
      t.decimal :lower_limit
      t.decimal :discount_value
      t.boolean :percentage
      t.boolean :applicable
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end

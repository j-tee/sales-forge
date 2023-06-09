class CreateDamages < ActiveRecord::Migration[7.0]
  def change
    create_table :damages do |t|
      t.references :product, null: false, foreign_key: true
      t.string :category
      t.integer :quantity
      t.date :damage_date

      t.timestamps
    end
  end
end

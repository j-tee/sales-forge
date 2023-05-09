class CreateTaxes < ActiveRecord::Migration[7.0]
  def change
    create_table :taxes do |t|
      t.string :name
      t.decimal :rate
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end

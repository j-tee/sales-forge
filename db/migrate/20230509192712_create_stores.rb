class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone1
      t.string :phone2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

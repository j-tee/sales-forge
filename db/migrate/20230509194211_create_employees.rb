class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :phone2
      t.string :phone1
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end

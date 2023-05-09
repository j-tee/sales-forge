class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :resource_type
      t.bigint :resource_id

      t.timestamps
    end
  end
end

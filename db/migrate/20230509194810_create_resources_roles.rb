class CreateResourcesRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :resources_roles do |t|
      t.references :resource, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end

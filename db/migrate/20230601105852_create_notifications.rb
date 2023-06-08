class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :type
      t.integer :value

      t.timestamps
    end
  end
end

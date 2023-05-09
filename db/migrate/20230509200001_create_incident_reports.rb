class CreateIncidentReports < ActiveRecord::Migration[7.0]
  def change
    create_table :incident_reports do |t|
      t.integer :product_id
      t.string :incident_type
      t.integer :qty
      t.date :incident_date

      t.timestamps
    end
  end
end

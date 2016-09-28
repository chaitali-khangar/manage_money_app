class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_type
      t.date :event_date
      t.string :location
      t.integer :total_amount

      t.timestamps null: false
    end
  end
end

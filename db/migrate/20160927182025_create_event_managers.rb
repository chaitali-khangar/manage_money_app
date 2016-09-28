class CreateEventManagers < ActiveRecord::Migration
  def change
    create_table :event_managers do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

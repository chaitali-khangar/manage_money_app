class AddAmountToEventManager < ActiveRecord::Migration
  def change
    add_column :event_managers, :amount, :float
  end
end

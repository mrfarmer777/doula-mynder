class AddClientDueDates < ActiveRecord::Migration
  def change
    add_column :clients, :due_date, :date
  end
end

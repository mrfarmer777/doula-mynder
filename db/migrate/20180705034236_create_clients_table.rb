class CreateClientsTable < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :age
      t.string :partner_name
      t.string :address
      t.integer :num_children
      t.integer :user_id
    end
  end
end

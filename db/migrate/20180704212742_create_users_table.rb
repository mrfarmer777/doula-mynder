class CreateUsersTable.rb < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :company_name
      t.string :password_digest
    end
  end
end

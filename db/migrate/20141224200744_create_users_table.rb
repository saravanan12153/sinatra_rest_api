class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :userid

      t.timestamps null: false
    end
    add_index :users, :userid
  end
end

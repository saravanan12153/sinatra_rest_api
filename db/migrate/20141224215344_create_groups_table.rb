class CreateGroupsTable < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :groups, :name
  end
end

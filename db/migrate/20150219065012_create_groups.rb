class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.boolean :visible, default: true, null: false

      t.timestamps null: false
    end

    create_join_table :groups, :users
  end
end

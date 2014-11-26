class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :text, null: false
      t.string :raw, null: false
      t.string :baked, null: false
      t.integer :author

      t.timestamps null: false
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :post_id, null: false
      t.integer :user_id, null: false
      t.integer :comment_number, null: false
      t.text :raw, null: false
      t.text :baked

      t.timestamps null: false
    end
  end
end

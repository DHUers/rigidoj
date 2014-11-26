class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :title, null: false
      t.string :description, default: ''
      t.boolean :published, default: false
      t.integer :author_id

      t.timestamps null: false
    end
  end
end

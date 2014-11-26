class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title, default: ''
      t.string :excerpt, default: ''
      t.text :raw, default: ''
      t.text :baked, default: ''
      t.integer :memory_limit, null: false, default: 65536
      t.integer :time_limit, null: false, default: 1000
      t.string :source, default: ''
      t.integer :author

      t.timestamps null: false
    end
  end
end

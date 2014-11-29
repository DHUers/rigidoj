class ReplaceDevise < ActiveRecord::Migration
  def change
    drop_table :users

    create_table :users do |t|
      t.string :username, null: false, length: 60
      t.string :name, length: 320
      t.string :password_hash, length: 64
      t.string :salt, length: 32
      t.boolean :active, default: false, null: false
      t.datetime :last_seen_at
      t.string :grade_and_class
      t.boolean :admin, default: false, null: false
      t.integer :solved_problem, default: 0
      t.inet :ip_address
      t.inet :registration_ip_address
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :last_seen_at
  end
end

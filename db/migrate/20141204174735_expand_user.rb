class ExpandUser < ActiveRecord::Migration
  def change
    change_column :users, :username_lower, :string, null: false, limit: 60
    remove_column :users, :grade_and_class
    add_column :users, :suspended, :boolean, null: false, default: false
    add_column :users, :suspended_at, :datetime
    add_column :users, :suspended_till, :datetime
    add_column :users, :last_emailed_at, :datetime
    add_column :users, :moderator, :boolean, default: false
    add_column :users, :locale, :string, limit: 10
    add_column :users, :uploaded_avatar_id, :integer
    add_column :users, :blocked, :boolean, default: false
    add_column :users, :email_notification, :boolean, default: true
    add_column :users, :email_digest, :boolean, default: false
    add_column :users, :email_contest_result, :boolean, default: true
    add_column :users, :email_solution_result, :boolean, default: false
    remove_column :users, :solved_problem

    create_table :user_profiles, id: false do |t|
      t.references :users, primary_key: true
      t.string :grade_and_class
      t.string :school
      t.string :website, limit: 255
      t.text :bio_raw
      t.text :bio_cooked
      t.string :profile_background
      t.string :card_background
    end

    create_table :user_stats, id: false do |t|
      t.references :users, primary_key: true
      t.integer :problems_entered, null: false, default: 0
      t.integer :problems_created, null: false, default: 0
      t.integer :time_read, null: false, default: 0
      t.integer :days_visited, null: false, default: 0
      t.integer :contests_created, null: false, default: 0
      t.integer :contests_joined, null: false, default: 0
      t.integer :solutions_created, null: false, default: 0
      t.integer :solutions_solved, null: false, default: 0
      t.datetime :first_solution_created_at
    end
  end
end

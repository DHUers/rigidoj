class CreateProblemSolutions < ActiveRecord::Migration
  def change
    create_table :problem_solutions, id: false do |t|
      t.integer :problem_id, null: false
      t.integer :user_id, null: false
      t.integer :solution_id
      t.datetime :last_submitted_at
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end

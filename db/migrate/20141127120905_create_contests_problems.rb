class CreateContestsProblems < ActiveRecord::Migration
  def change
    create_table :contests_problems, id: false do |t|
      t.belongs_to :contest
      t.belongs_to :problem
    end
  end
end

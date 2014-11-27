class CreateContestsProblems < ActiveRecord::Migration
  def change
    create_table :contests_problems, id: false do |t|
      t.belongs_to :contests
      t.belongs_to :problems
    end
  end
end

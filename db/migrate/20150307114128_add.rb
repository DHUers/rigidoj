class Add < ActiveRecord::Migration
  def change
    add_column :user_problem_stats, :first_accepted_at, :datetime
  end
end

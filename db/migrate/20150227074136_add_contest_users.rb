class AddContestUsers < ActiveRecord::Migration
  def change
    create_join_table :contest, :user, table_name: 'contest_users'
  end
end

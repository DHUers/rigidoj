class AddMetaInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :crew, :string
    add_column :users, :student_id, :string
  end
end

class AddDefaultValueToProblemPublished < ActiveRecord::Migration
  def change
    change_column :problems, :published, :boolean, default: false
  end
end

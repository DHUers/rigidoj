class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :upload_id
      t.string :upload_filename
      t.integer :upload_size
      t.string :upload_content_type

      t.timestamps null: false
    end
  end
end

class CreateUserSearchData < ActiveRecord::Migration
  def up
    create_table :user_search_data, id: false do |t|
      t.integer :user_id, null: false, primary_key: true
      t.tsvector :search_data
      t.text :raw_data
    end

    execute 'CREATE INDEX idx_search_user ON user_search_data USING gin(search_data)'
  end

  def down
    drop_table :user_search_data
  end
end

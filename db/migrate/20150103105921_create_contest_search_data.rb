class CreateContestSearchData < ActiveRecord::Migration
  def up
    create_table :contest_search_data, id: false do |t|
      t.integer :contest_id, null: false, primary_key: true
      t.tsvector :search_data
      t.text :raw_data
    end

    execute 'CREATE INDEX idx_search_contest ON contest_search_data USING gin(search_data)'
  end

  def down
    drop_table :contest_search_data
  end
end

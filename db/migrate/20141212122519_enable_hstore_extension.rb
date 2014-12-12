class EnableHstoreExtension < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    remove_column :problems, :memory_limit
    remove_column :problems, :time_limit
    add_column :problems, :memory_limit, :hstore, default: '', null: false
    add_column :problems, :time_limit, :hstore, default: '', null: false
  end
end

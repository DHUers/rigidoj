class EnableHstoreExtension < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    rename_column :problems, :memory_limit, :default_memory_limit
    rename_column :problems, :time_limit, :default_time_limit
    add_column :problems, :additional_memory_limit, :hstore, default: {}, null: false
    add_column :problems, :additional_time_limit, :hstore, default: {}, null: false
  end
end

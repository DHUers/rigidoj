class EnableHstoreExtension < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    remove_column :problems, :memory_limit
    add_column :problems, :default_memory_limit, :string, null: false, default: 65535
    remove_column :problems, :time_limit, :default_time_limit
    add_column :problems, :default_time_limit, :string, null: false, default: 1000
    add_column :problems, :additional_limits, :hstore, default: [], null: false, array: true
  end
end

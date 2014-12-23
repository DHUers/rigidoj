class ChangeToJsonb < ActiveRecord::Migration
  def change
    remove_column :problems, :additional_limits
    add_column :problems, :additional_limits, :jsonb, default: []
    disable_extension 'hstore' if extension_enabled?('hstore')
  end
end

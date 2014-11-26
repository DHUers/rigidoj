class RemovePostsBakedAttrConstraint < ActiveRecord::Migration
  def change
    change_column :posts, :baked, :text, default: ''
  end
end

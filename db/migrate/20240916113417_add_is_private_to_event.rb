class AddIsPrivateToEvent < ActiveRecord::Migration[7.2]
  def up 
    add_column :events, :is_private, :boolean, null: false, default: false
  end

  def down
    remove_column :events, :is_private
  end
end

class AddPositionToMenuObjects < ActiveRecord::Migration[5.1]
  def change
    add_column :menu_objects, :position, :integer, default: 0
  end
end

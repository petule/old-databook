class CreateMenuObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_objects do |t|
      t.references :menu
      t.integer :object_id
      t.string :object_class
      t.references :language

      t.timestamps
    end
  end
end

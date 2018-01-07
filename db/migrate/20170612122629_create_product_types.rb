class CreateProductTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :product_types do |t|
      t.string   :name
      t.string   :code
      t.integer  :position
      t.boolean  :pub

      t.timestamps
    end
  end
end

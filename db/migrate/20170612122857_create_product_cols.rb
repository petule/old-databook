class CreateProductCols < ActiveRecord::Migration[5.1]
  def change
    create_table :product_cols do |t|
      t.string   :col
      t.string   :title
      t.boolean  :product_cart, default: false
      t.references  :product_type
      t.boolean  :pub
      t.integer  :position

      t.timestamps
    end
  end
end

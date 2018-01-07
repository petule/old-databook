class CreateProductPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :product_prices do |t|
      t.string   :title
      t.decimal  :price
      t.decimal  :original_price
      t.decimal  :original_price2
      t.boolean  :pub, default: true
      t.references  :currency
      t.integer  :position
      t.references  :product
      t.boolean  :main, default: true

      t.timestamps
    end
  end
end

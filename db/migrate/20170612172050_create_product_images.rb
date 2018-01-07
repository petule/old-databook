class CreateProductImages < ActiveRecord::Migration[5.1]
  def change
    create_table :product_images do |t|
      t.string   :title
      t.boolean  :pub, default: true
      t.boolean  :main, default: true
      t.references  :product
      t.attachment :image

      t.timestamps
    end
  end
end

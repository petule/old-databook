class CreateCategoriesProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_products do |t|
      t.references :product
      t.references :category

      t.timestamps
    end
  end
end

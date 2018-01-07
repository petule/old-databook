class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :sub_title
      t.string :code
      t.string :ean
      t.string :pretext
      t.text :text
      t.references :publisher
      t.string :var1
      t.string :var2
      t.string :var3
      t.string :var4
      t.string :var5
      t.string :var6
      t.string :var7
      t.string :var8
      t.integer :x1
      t.integer :x2
      t.integer :x3
      t.integer :x4
      t.integer :x5
      t.integer :x6
      t.boolean :b1
      t.boolean :b2
      t.boolean :b3
      t.boolean :b4
      t.boolean :b5
      t.boolean :b6
      t.boolean :pub
      t.references :product_type
      t.references :category
      t.integer :sale
      t.date :start_at
      t.date :end_at
      t.references :product_state
      t.decimal :d1
      t.decimal :d2
      t.decimal :d3
      t.decimal :d4
      t.decimal :d5
      t.decimal :d6

      t.timestamps
    end
  end
end
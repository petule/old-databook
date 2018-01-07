class CreateDphProductTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :dph_product_types do |t|
      t.references :dph
      t.references :product_type

      t.timestamps
    end
  end
end

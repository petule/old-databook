class CreateProductStates < ActiveRecord::Migration[5.1]
  def change
    create_table :product_states do |t|
      t.string   :code
      t.integer  :position

      t.timestamps
    end
  end
end

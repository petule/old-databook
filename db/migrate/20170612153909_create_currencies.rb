class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string   :code
      t.string   :title
      t.decimal  :exchange_rate
      t.boolean  :exchange, default: false
      t.boolean  :pub, default: true

      t.timestamps
    end
  end
end

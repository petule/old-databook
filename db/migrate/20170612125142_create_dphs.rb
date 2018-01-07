class CreateDphs < ActiveRecord::Migration[5.1]
  def change
    create_table :dphs do |t|
      t.integer  :val
      t.integer  :position
      t.boolean  :pub
      t.references :language

      t.timestamps
    end
  end
end

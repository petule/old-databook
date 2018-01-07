class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string   :code
      t.string   :url
      t.string   :title
      t.boolean  :pub
      t.references :currency

      t.timestamps
    end
  end
end

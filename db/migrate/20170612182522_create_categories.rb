class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string   :title
      t.text   :h1
      t.text     :pretext
      t.text     :txt
      t.boolean  :pub,                               default: true
      t.references  :category
      t.references  :language
      t.string   :url
      t.string :code
      t.integer  :position
      t.boolean  :root,                              default: false
      t.boolean  :params,                            default: false
      t.attachment   :avatar

      t.timestamps
    end
  end
end

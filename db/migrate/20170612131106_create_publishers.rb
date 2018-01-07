class CreatePublishers < ActiveRecord::Migration[5.1]
  def change
    create_table :publishers do |t|
      t.string   :title
      t.string   :email
      t.string   :address
      t.string   :city
      t.string   :zip
      t.string   :contact_name
      t.string   :contact_email
      t.string   :contact_tel
      t.boolean  :print
      t.boolean  :copy
      t.boolean  :drm

      t.timestamps
    end
  end
end

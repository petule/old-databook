class CreateSetting < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :key
      t.integer :integer_value
      t.string :string_value
      t.boolean :boolean_value
      t.decimal :decimal_value

      t.timestamps
    end
  end
end

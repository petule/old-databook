class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :code

      t.timestamps
    end

    Menu.where(code: 'top').first_or_create
    Menu.where(code: 'main').first_or_create
    Menu.where(code: 'left').first_or_create
    Menu.where(code: 'footer_left').first_or_create
    Menu.where(code: 'footer_right').first_or_create
  end
end

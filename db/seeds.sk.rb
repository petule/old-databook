# CS data

# puts 'DEFAULT USERS'
# [
#   {first_name: 'Unknown', last_name: 'Guest', email: 'unknown@databook.cz', password: '0.*.+.-.', role: :guest},
#   {first_name: 'Main', last_name: 'Admin', email: 'admin@databook.cz', password: 'databook.324', role: :admin}
# ].each do |info|
#   user = User.create_with(first_name: info[:first_name], last_name: info[:last_name], password: info[:password], password_confirmation: info[:password]).find_or_create_by email: info[:email]
#   raise user.errors.inspect if user.errors.any?
#   unless user.previous_changes.empty?
#     puts 'user: ' << user.name
#     user.add_role info[:role]
#   end
#   user = nil
# end

# puts 'CATEGORY'
# [
#   {code: 'XXXX' ,name: 'Xxxxxxx yyy  yyyy y'},
#   {code: 'ZZZZ' ,name: 'Zzzzzz dddd ddd'},
# ].each do |info|
#   category = Category.create_with(info).find_or_create_by(code: info[:code])
#   raise category.errors.inspect if category.errors.any?
#   puts 'category: ' << category.name unless category.previous_changes.empty?
# end

#lang_sk = Language.find_by(code: 'sk')


puts 'creating currency'
  sk = Currency.where(code: 'EUR', exchange_rate: '1', exchange: false, pub: true).first_or_create!
  sk.save
lang_sk = Language.where(code: 'sk', url: 'neco.sk', pub: true, title: 'slovensky', currency_id: sk.id).first_or_create!
lang_sk.save

puts 'create category'
  Category.where(url: 'novinky-sk', title: 'Novinky', h1: 'Nase novinky', language_id: lang_sk.id,
                 code: 'news', root: true).first_or_create

  Category.where(url: 'akce-slevy-sk', title: 'Akce slevy', h1: 'nadpis akce, slevy',
                 language_id: lang_sk.id, code: 'news', root: true).first_or_create

  category = Category.where(url: 'nejaka-kategorie-sk', title: 'Nejaka kategorie',
                            h1: 'nadpis Nejaka kategorie', language_id: lang_sk.id).first_or_create
  category.save
  Category.where(url: 'nejaka-podkategorie-sk', title: 'Nejaka podategorie',
                 h1: 'nadpis Nejaka podkategorie', language_id: lang_sk.id,
                 category_id: category.id).first_or_create

puts 'create menu object'
  menu = Menu.first
  MenuObject.where(menu_id: menu.id, object_id: category.id, object_class: 'Category',
                   language_id: lang_sk.id).first_or_create!
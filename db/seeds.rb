# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

# puts 'ROLES'
# ['guest', 'user', 'admin'].each do |role|
#   puts 'role: ' << role unless Role.find_or_create_by!(name: role).previous_changes.empty?
# end

# http://www.kurzy.cz/forex/
# puts 'CURRENCY'
# [
#   {code: 'CZK', exchange_rate: BigDecimal.new('24')},
#   {code: 'USD', exchange_rate: BigDecimal.new('1')},
#   {code: 'HOP', exchange_rate: BigDecimal.new('1')},
#   {code: 'EUR', exchange_rate: BigDecimal.new('0.9')}
# ].each do |info|
#   currency = Currency.create_with(exchange_rate: info[:exchange_rate]).find_or_create_by code: info[:code]
#   raise currency.errors.inspect if currency.errors.any?
#   puts 'currency: ' << currency.code unless currency.previous_changes.empty?
# end
puts 'creating languages '
  lang_cs = Language.where(code: 'cs', url: 'neco.cz', pub: true, title: 'česky').first_or_create
  lang_sk = Language.where(code: 'sk', url: 'neco.sk', pub: true, title: 'slovensky').first_or_create

puts 'creating default menu'
  Menu.where(code: 'top').first_or_create
  Menu.where(code: 'main').first_or_create
  Menu.where(code: 'left').first_or_create
  Menu.where(code: 'footer_left').first_or_create
  Menu.where(code: 'footer_right').first_or_create

puts "loading seeds for #{lang_cs} locale ..."
require_relative "seeds.#{lang_cs}"

puts "loading seeds for #{lang_sk} locale ..."
require_relative "seeds.#{lang_sk}"

AdminUser.where(email: 'admin@example.com')
    .first_or_create(password: 'password', password_confirmation: 'password')




puts ''
ActiveAdmin.register Setting do

  menu :parent => I18n.t('active_admin.menu.system_settings'), :priority => 1

  permit_params :key, :integer_value, :string_value, :boolean_value, :decimal_value

  filter :key
  filter :integer_value
  filter :string_value
  filter :boolean_value, as: :select, collection: [[I18n.t('yes'), 'true'], [I18n.t('no'), 'false']]
  filter :decimal_value
  filter :created_at
  filter :updated_at

  index do
    column (:key ){|set| "#{set.to_s}  (#{set.key})"}
    column :integer_value
    column :string_value
    column :boolean_value
    column :decimal_value
    column (:created_at)
    column (:updated_at)
    actions
  end

end

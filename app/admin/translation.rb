ActiveAdmin.register Translation do
  menu :parent => I18n.t('active_admin.menu.system_settings'), priority: 5
  permit_params :locale, :key, :value, :interpolations, :is_proc

end

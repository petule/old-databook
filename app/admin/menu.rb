ActiveAdmin.register Menu do
  menu :parent => I18n.t('active_admin.menu.system_settings'), :priority => 2
  config.sort_order = 'id_asc'

  actions :index, :show

  index do
   # selectable_column
    column :id
    column(:code, :sortable => :code){|menu| link_to menu.code,( admin_menu_path (menu.id) )}
    column (I18n.t('activerecord.attributes.menu.code_title') ){|menu|link_to menu.to_s, ( admin_menu_path (menu.id) )}

    actions
  end

  show title: :to_s do
    attributes_table do
      row :id
      row :code
      row (I18n.t('activerecord.attributes.menu.code_title')){|menu| menu.to_s}
      row(:created_at) #${format_date(resource.created_at)}
      row(:updated_at)# {format_date(resource.updated_at)}

      active_admin_comments
    end

  end
end

ActiveAdmin.register MenuObject do
  menu parent: I18n.t('active_admin.menu.category'), priority: 2
  config.filters = false
  config.batch_actions = false

  permit_params  :menu_id, :object_id, :object_class, :position, :language_id
# actions :index, :show,  :destroy

  Language.all.each do |language|
    scope (language.to_s) { |menu_object| menu_object.by_language(language) }
  end if ActiveRecord::Base.connection.table_exists? 'languages'

  index do
    i do
      t 'active_admin.help.sortable'
    end
    Menu.all.each do |menu|
      # Menu.by_menu_objects(collection).each do |menu|
      panel menu.to_s, id: "menu-#{menu.id}" do
        render partial: 'panel', locals: { menu: menu }
        code = params[:scope] ? params[:scope] : 'cs'
        render partial: 'new_form', locals: { menu: menu, language: Language.find_by_code(code) }
      end
    end

  end

  show do
    attributes_table do
      row :id
      row :menu
      row :object_class do
        "#{link_to resource.object.to_s, eval("admin_#{resource.object_class.underscore}_path(#{resource.id})") }
                  (#{t("activerecord.models.#{resource.object_class.underscore}.one")})".html_safe
      end

      row :language
      row :position
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end



  collection_action :set_position_menu, method: :post do
    params[:page].each_with_index do |page, i|
      obj = MenuObject.find(page)
      obj.update_columns(position: i+1)
    end
  end

  collection_action :new_menu, method: :post do
    par = params[:menu_object]
    obj_class = par[:object].split("_")

    obj = eval(obj_class[0]).find(obj_class[1])
    MenuObject.create(
      menu_id: par[:menu_id],
      object_id: obj_class[1],
      object_class: obj_class[0],
      position: 0,
      language_id: par[:language_id]
    )
    language = Language.find(par[:language_id])
    redirect_to admin_menu_objects_path(scope: language.code), notice:  I18n.t('active_admin.batch_actions.add_to_menu')
  end

  controller do
    def destroy
      menu_object = MenuObject.find(params[:id])
      language = menu_object.language
      menu_object.destroy
      redirect_to admin_menu_objects_path(:scope=>language.code), notice:  I18n.t('active_admin.controller.menu_object.destroy')
    end
  end
end
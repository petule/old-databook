ActiveAdmin.register Category do
  menu :parent => I18n.t('active_admin.menu.category'), :priority => 1
  
  permit_params  :title, :h1, :pretext, :txt, :avatar, :pub, :position, :params, :language_id,
                 :url, menu_ids: [], product_ids: []

  #actions :index, :show, :update, :edit, :new, :create

  filter :id
  filter :title
  filter :url
  filter :code, as: :select, multiple: true,
         input_html: { multiple: true, class: 'select2', style: 'width: 100%;' },
         collection: [[I18n.t('model.category.code.news'), 'news'], [I18n.t('model.category.code.discount'), 'discount']]
  #filter :position
  filter :txt
  filter :language, input_html: { class: 'select2',  style: 'min-width:200px' }
  filter :products, as:  :select, multiple: true,
         input_html: { multiple: true, class: 'select2', style: 'width: 100%;' },
         collection: Product.all.map{|u| ["#{u.to_s}", u.id] }
  filter :menu_objects, :as => :select, :multiple => true,
         input_html: { multiple: true, class: 'select2', style: 'width: 100%;' },
         collection: Menu.all.map{ |u| ["#{u.to_s}", u.id] }
  filter :pub, input_html: { class: 'select2', style: 'min-width:200px' },
         as: :select, collection: [[I18n.t('yes'), 'true'], [I18n.t('no'), 'false']]
  filter :root, input_html: { class: 'select2', style: 'min-width:200px' }, as: :select,
         collection: [[I18n.t('yes'), 'true'], [I18n.t('no'), 'false']]
  scope :all, default: true

  Language.all.each do  |language|
    scope (language.to_s){|category| category.by_language(language)}
  end if ActiveRecord::Base.connection.table_exists? 'languages'


  index do
    selectable_column
    column :id
    column(:title, sortable: title){|category| link_to category.title,( admin_category_path (category.id) )}
    column (:avatar){ |category| image_tag(category.avatar.url(:thumb)) }
    column (:like){|category|status_tag(I18n.t(category.like ? I18n.t('yes') : I18n.t('no')), category.like ? 'yes' : 'no')}
    column (:pub){|category|status_tag(I18n.t(category.pub ? I18n.t('yes') : I18n.t('no')), category.pub ? 'yes' : 'no')}
    column (:root){|category|status_tag(I18n.t(category.root ? I18n.t('yes') : I18n.t('no')), category.root ? 'yes' : 'no')}
    column (:menus){|category|category.menus.map{|menu| link_to menu.to_s, admin_menu_path(menu.id)}.join(', ').html_safe}

    #actions
    column(){|category|
      "#{link_to I18n.t('active_admin.view'), admin_category_path(category.id), title: I18n.t('active_admin.view') }&nbsp
      #{link_to I18n.t('active_admin.edit'), edit_admin_category_path(category.id), title: I18n.t('active_admin.edit') }&nbsp;
      #{!category.root ? link_to( I18n.t('active_admin.delete'), admin_category_path(category.id),
                                  method: delete, confirm: I18n.t('active_admin.delete_confirmation')) : '' }".html_safe
    }
  end

  show do
    attributes_table do
      row :id
      row :title
      row :avatar do
        image_tag(category.avatar.url(:medium))
      end
      row :url
      #row :position
      row :pretext do
        category.pretext.try(:html_safe)
      end
      row :txt do
        category.txt.try(:html_safe)
      end
      if category.root
        row :code do
          I18n.t("model.category.code.#{category.code}")
        end
      end
      row :pub do
        status_tag(I18n.t(category.pub ? I18n.t('yes') : I18n.t('no')), category.pub ? 'yes' : 'no')
      end
      row :params do
        status_tag(I18n.t(category.params ? I18n.t('yes') : I18n.t('no')), category.params ? 'yes' : 'no')
      end
      row :root do
        status_tag(I18n.t(category.root ? I18n.t('yes') : I18n.t('no')), category.root ? 'yes' : 'no')
      end
      unless category.root
        row :products do
          category.products.map{|product|  link_to product.to_s, edit_admin_product_path(product) }.join(', ').html_safe
        end
      end
      row :language do
        link_to category.language.to_s, admin_language_path(category.language)
      end
      row :menus do
        category.menus.map{|menu| link_to menu.to_s, admin_menu_path(menu.id)}.join(", ").html_safe
      end
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    tabs do
      tab "#{t('active_admin.tabs.category.main')}" do
        f.inputs class: "no-border" do
          f.input :title
          f.input :url
          f.input :avatar
          f.input :like
          f.input :params
          f.input :pub
          f.input :position
          f.input :menus, input_html: { class: 'select2', style: 'min-width:200px' },
                  collection: Hash[Menu.all.map{|b| [b.to_s,b.id] }]
          f.input :language, input_html: { class: 'select2', style: 'min-width:200px' },
                  collection: Hash[Language.all.map{|b| [b.to_s,b.id] }]
          f.input :pretext, input_html: { class: 'ckeditor', ckeditor: { language: 'cs' } }
          f.input :txt, input_html: { class: 'ckeditor', ckeditor: { language: 'cs' } }
        end
      end
    end

    f.actions
  end

  controller do
    def update
      super
      MenuObject.where(menu_id: permitted_params[:category][:menu_ids], object_class: nil,
                       object_id: params[:id]).update_all(object_class: 'Category')
    end

    def create
      super
    end
  end
end

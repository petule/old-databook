class MenuObject < ApplicationRecord

  belongs_to :menu
  belongs_to :language

  ransacker :object,
            formatter: proc { |object_id|
              results = MenuObject.has_object(object_id).map(&:id)
              results = results.present? ? results : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  scope :by_language, lambda { |language| where(language_id: language.id ) }

  scope :by_menu, lambda { |menu| where(:menu_id =>menu.id ).order(:position) }

  after_create :insert_language

  def self.free_objects menu, language
    objs = ['Category']
    sel = Array.new

    objs.each do |obj_class|
      eval("#{obj_class}").by_language(language).each do |obj|
        sel << ["#{obj.to_s} (#{I18n.t("activerecord.models.#{obj_class.underscore}.one") })", "#{obj_class}_#{obj.id}"] if obj.menu_objects.where(:menu_id=>menu.id).count==0
      end
    end
    sel
  end

  def self.by_menu_obj menu, collection
    MenuObject.where(menu_id: menu.id).where(id: collection.pluck(:id)).order(:position)
  end

  def self.menus objs
    arr = objs.pluck(:menu_id).uniq
    Menu.where(id: arr)
  end

  def self.has_object(object_id)
    ids = Array.new
    MenuObject.where(object_id: object_id).each  do |menu_object|
      ids << menu_object.id if menu_object.object
    end
    MenuObject.find(ids)
  end

  def self.filter_objects
    filter = Array.new
    MenuObject.all.each do |menu_object|
      obj = menu_object.object
      filter << [obj.to_s, obj.id]
    end
    filter.uniq
  end

  def insert_language
    update_columns(language_id: object.language_id) if object
  end

  def object
    eval("#{self.object_class}.find(#{self.object_id})") if self.object_class && self.object_id
  end

  def query_object
    eval("#{self.object_class}.find(#{self.object_id})") if self.object_class && self.object_id
  end

  def link_object
    return unless self.object_class && self.object_id
    obj = self.object
    #puts " link_to #{obj.to_s}, admin_#{self.object_class.tableize.singularize}_path(#{obj.id})"
    eval(" link_to obj.to_s, admin_#{self.object_class.tableize.singularize}_path(#{obj.id})")
  end
end
class Category < ApplicationRecord
  belongs_to :language

  has_many :categories, dependent: :destroy
  alias_method :children, :categories

  #belongs_to :category
  #belongs_to :parent, class_name: 'Category', foreign_key: "id", required: false

  belongs_to :category, required: false
  alias_method :parent, :category

  has_many :menu_objects, -> (object){ where("object_class = 'Category' ")},
           class_name: 'MenuObject', foreign_key: "object_id", dependent: :destroy
  has_many :menus, through: :menu_objects

  has_many :products_categories
  has_many :products, through: :products_categories

  validates :url, uniqueness: true
  validates :url, :language_id, presence: true

  has_attached_file :avatar, styles: { medium: '218x145', thumb: '100x100>' }, default_url: '/missing/categories/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  scope :by_language, lambda { |language| where(language_id: language.id ) }
  scope :by_menu, lambda { |menu| joins(:menu_objects).
      where(menu_objects: { menu_id: menu.id }).where("object_class='Category'") }
  scope :by_like, -> { where(like: true) }
  scope :by_params, lambda{ |category| where.not(id: category).where(params: true) }
  scope :by_code, lambda{ |code| where(code: code) }
  scope :by_root, -> { where(root: true) }

  after_update  :update_language if :language_id_changed?
  after_create :update_language, :set_class_menu

  def parent_ids
    category = self
    ids = Array.new
    loop do
      category = category.parent
      break if category.nil?
      ids << category.id
    end
    ids
  end

  def root?
    root
  end

  def news?
    code == 'news' && root
  end

  def discount?
    code == 'discount' && root
  end

  def count_children
    if self.children.any?
      sum = self.children.count
      self.children.each do |child|
        sum+=child.count_children
      end
      sum
    else
      0
    end.to_i
  end

  def to_s
    title
  end

  #kvuli max 3 sloupcum
  def max_col
    max = 15
    count  = self.count_children + 1
    if count>(3*max)
      count/3
    else
      max
    end
  end

  #TODO WTF????
  def view_pretext
    if pretext && pretext.length>0
      "#{pretext[0,600]}#{"..." if pretext.length>600}"
    else
      "#{txt[0,600]}#{"..." if txt && txt.length>600}" if txt
    end
  end
  
	#def ordering( order)
	#	self.products.published.
	#end
	
	def is_parent?
		Category.exists?(category_id: self.id)
	end

  def self.new_products
		Product.where(del: false, published: true)
	end

	#spocita posice pro active admina
	def calculate_position 
		@i=0
		Category.by_parents.order("position").each do |cat|
      @i +=1
			#Category.update(cat.id,:total_position=> i)
			Category.where(id: cat.id).update_all(:total_position=> @i)
			set_position(cat.id)			
		end
  end

  def build_nav
    category = self
    nav = Array.new
    loop do
      nav << { url: category.url, title: category.to_s }
      category = category.parent
      break if category.nil?
    end
    nav.reverse!
  end
	
	def full_url
		cat = self.category_id
		i = 0
		num = 3
		url=self.url
			until cat.nil? || i > num  do
				if cat					
					next_cat = Category.find(cat)
					if next_cat
						url = next_cat.url + '/' + url
						cat = next_cat.category_id
					else
						cat=nil					
					end
				end
				i +=1
			end	
			url
	end
	
	#pocita zanoreni kategorie
	def level
			multiple=25			
			cat=self.category_id
			i = 0
			num = 10					
			until cat.nil? || i > (num * multiple)  do
				if cat
            next_cat=Category.find(cat)
            if next_cat
              cat = next_cat.category_id
            else
              cat=nil					
            end
          
				end
				i +=1
			end	
			i*multiple	
	end
	
	def admin_title
		title
	end
	
	private
	
	def set_position id
		Category.by_parent(id).order(:position).each do |cat|
			@i +=1
			Category.where(id: cat.id).(:total_position=> @i)
			set_position(cat.id)			
		end
  end

  def update_language
    menu_objects.each do |obj|
      obj.update_columns(language_id: self.language_id)
    end
  end

  def set_class_menu
    menu_objects.each do |obj|
      obj.update_columns(object_class: self.class.name)
    end
  end
end

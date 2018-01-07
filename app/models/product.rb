class Product < ApplicationRecord

  require 'net/ftp'

  belongs_to :publisher
  belongs_to :product_type
	belongs_to :category
	belongs_to :product_state
  belongs_to :publisher
  alias_method :state, :product_state

  #has_many :line_items
  #has_many :attachments

  #has_many :authors_products
  #has_many :authors, through: :authors_products

  #has_many :translators_products
  #has_many :translators, through: :translators_products

  has_many :product_prices , :dependent => :destroy
  alias_method :prices, :product_prices

  has_many :categories_products
  has_many :categories, through: :categories_products

  has_many :product_images
  alias_method :images, :product_images

  #souvisejici
  #has_many :relateds

  #validace
  validates :title, :presence => true
  validates :title, :uniqueness => true

  validates :publisher, :presence => true

  validates :product_type, :presence => true

  accepts_nested_attributes_for :categories_products, allow_destroy: true
  #accepts_nested_attributes_for :translators_products, allow_destroy: true
  #accepts_nested_attributes_for :authors_products, allow_destroy: true

  #pro nenulove ceny
  #scope :published, ->{where(:pub=>true).joins(:product_state).where(:product_states=>{:code=>"valid"}).where("(select count(*) from product_prices where product_prices.product_id=products.id and product_prices.pub )>0")}
  scope :published, ->{ where(pub: true).joins(:product_state).where(:product_states=>{ code: 'valid' }) }
  scope :by_low_price, ->{ select('products.*, (select min(price) from product_prices where product_prices.product_id=products.id) min_price' ).order('min_price asc, title')}
  scope :by_newest, ->{where("EXTRACT(day FROM now()-products.created_at)::int < #{Setting.new_product}")}
  scope :by_new_products, ->{where("EXTRACT(day FROM now()-products.created_at)::int < #{Setting.new_product}")}
  scope :by_bestseller, ->{where(b2: true)}
  scope :by_top_seller, ->{select('products.*, (select count(price) from order_products where order_products.product_id=products.id) count_seller' ).order('count_seller asc, title') }
  scope :by_title, ->{order(:title)}
  scope :by_autors, ->{joins(:authors).order('authors.surname')}
  scope :by_related_except, lambda { |product| where('products.id not in ( select related_id from relateds where product_id = ? )', product.id).select('DISTINCT products.*')	}

  scope :by_state, lambda{|state| joins(:product_state).where(:product_states=>{:id=>state.id})}
  scope :by_pub, ->{ joins(:product_state).where(:product_states=>{:id=>state.id})}



  def to_s
    title
  end


  def self.by_find title
    title = I18n.transliterate(title.downcase.strip) if title
    Product.where("products.pub AND ( unaccent('unaccent',products.title) ilike ? or unaccent('unaccent',products.pretext) ilike ?
                  or unaccent('unaccent',products.text) ilike ? or unaccent('unaccent',products.code) ilike ? or unaccent('unaccent',products.ean) ilike ? )",
                  "%#{ title }%","%#{ title }%","%#{ title }%","%#{ title }%","%#{ title }%"  ).published
  end

  def order_title # tady dat, co se bude kopirovat do produktu v objednavce
    "#{title}"
  end

  def self.build_get_params params
    names = ['ordering', 'bestseller', 'like', 'discount', 'epub', 'mobi', 'pdf' ]
    params.select { |k,v| names.include?(  k) }
  end

  #filtruje produkty
  def self.get_products_scope(cat_products, params)
    url_params = build_get_params params
    params[:limit] = 12
    params[:page] = 1 if params[:page].nil?
    products_count = 0
    if params[:ordering].nil?
      params[:ordering] = 'by_low_price'
    elsif  params[:ordering] == I18n.t('app.www.filter.by_top_seller')
      params[:ordering] = 'by_top_seller'
    elsif  params[:ordering] == I18n.t('app.www.filter.by_title')
      params[:ordering]="by_title"
    elsif  params[:ordering] == I18n.t('app.www.filter.by_autors')
      params[:ordering] = 'by_autors'
    else
      params[:ordering] = 'by_newest'
    end
    where = Array.new
    where << 'b2' if params[:bestseller]
    where << 'b3' if params[:like]

    if where.any?
      products = cat_products.where(where.join( ' and '))
    else
      products = cat_products
    end

    if params[:discount] || params[:epub]|| params[:mobi]|| params[:pdf]
      ids_price = Array.new
      ids_attachment = Array.new
      products.each do |product|
        if params[:discount]
          ids_price << product.id if product.sale?
        end
        #typy souboru
        if  params[:epub] || params[:mobi]|| params[:pdf]
          types = Array.new
          types << 'ePub' if params[:epub]
          #types << "mobi/Kindle" if params[:mobi]
          types << 'ePub' if params[:mobi]
          types << 'PDF' if params[:pdf]
          types = AttachmentType.where(code: ypes).pluck(:content_type)
          ids_attachment << product.id if product.attachments.exists?(attachment_content_type: types)
        end
      end
      products = products.where(id: ids_price) if params[:discount]
      products = products.where(id: ids_attachment) if params[:epub] || params[:mobi] || params[:pdf]
    end

    params[:products_count] = products.count
    #puts "TESTS #{params[:ordering]}"
    products = products.send(params[:ordering]).limit(params[:limit]).offset(((params[:page].to_i) -1 )  * params[:limit].to_i)
    return params, url_params, products
  end

  def self.no_active products
    ids = Array.new
    products.each do |product|
      ids << product.id unless product.active?
    end
    Product.where(:id=>ids)
  end

  def self.active products
    ids = Array.new
    products.each do |product|
      ids << product.id if product.active?
    end
    Product.where(id: ids)
  end

  def valid!
    self.product_state_id = ProductState.find_by_code('valid').id
    save!
  end

  # TODO vymazat - je to hnusny
  def is_valid?
    self.product_state.code == 'valid'
  end

  def active?
    date = true
    if start_at && end_at
      date = (start_at..end_at).include?(Date.today)
    elsif start_at
      date = start_at <= Date.today
    elsif end_at
      date = Date.today < end_at
    end
    pub && date
  end

  def free?
    price = main_price
    (active? && !(price &&  price.price && price.price>0))
  end

  # TODO prehodnotit, jestli tohle nutny...
  def create_dph
    dph = Dph.where(:val=>Dph.ebook_dph, :currency_id=>Currency.find_by_code("CZK").id).first
    dph_eur = Dph.where(:val=>Dph.ebook_dph_eur, :currency_id=>Currency.find_by_code("EUR").id).first
    DphsProduct.create(:product_id => self.id,:dph_id => dph.id)
    DphsProduct.create(:product_id => self.id,:dph_id => dph_eur.id)
  end

  # TODO prehodnotit, jestli tohle nutny..
  def update_others(params, product)
    params[:product_price][:price] = "0" if params[:product_price][:price]==""
    if params[:product_price_id] && params[:product_price_id]!=""
      @product_price = ProductPrice.find(params[:product_price_id])
    else
      @product_price = ProductPrice.new
    end

    @product_price.update_attributes(params[:product_price])

    #obalka
    errors = Array.new
    if params[:product_image] && params[:product_image][:image]
      if params[:product_image][:id] && params[:product_image][:id]!=""
        image= ProductImage.find(params[:product_image][:id])
      else
        image= ProductImage.new
      end
      image.update_attributes(:image=>params[:product_image][:image],  :product_id => product.id)
      if image.errors.any?
        errors << image.errors.full_messages
      end
    end

    #soubory
    if params[:attachments]
      params[:attachments].each do |attachment|
        att = attachment[1]
        if att[:attachments]
          attachment = Attachment.create(:attachments=>att[:attachments], :sample=>att[:sample], :product_id => product.id)
          if attachment.errors.any?
            errors<<attachment.errors.full_messages
          end
        end
      end
    end
    errors if errors.any?
  end

  def active?
    date = true
    if start_at && end_at
      date = (start_at..end_at).include?(Date.today)
    elsif start_at
      date = start_at<=Date.today
    elsif end_at
      date = Date.today<end_at
    end
    pub && date
  end

  def info_prices
    arr = Array.new
    prices.each do |price|
      arr << price.price_info
    end
    arr.join(", ")
  end

	def main_category
		if self.category
			self.category
		else      
			cat = self.categories_products.first
      return Category.find(cat.category_id) if cat && cat.category_id
		end
	end
	
	def set_ebook_type
    self.product_type_id = ProductType.find_by_code('ebook').id
  end

  # TODO prehodnotit, jestli tohle nutny..
	def empty_image size=nil
    if size
      "/system/product_images/#{size}/missing.png"
    else
      "/system/categories/missing.jpg"
    end

	end

  # TODO prehodnotit, jestli tohle nutny..
  def main_image_simple
    if self.images.by_main.exists?
      self.images.by_main.first.image
    else
      self.images.published.first.image
    end
  end

  # TODO prehodnotit, jestli tohle nutny..
	def main_image size=nil
    size = :medium if size.nil?
		if self.images.any?
			if self.images.by_main.exists?
				self.images.by_main.first.image.url(size)
			else
				self.images.published.first.image.url(size)
			end
		else
			#"/system/product_images/missing.jpg"
      "/system/product_images/#{size}/missing.png"
		end		
	end

  # TODO prehodnotit, jestli tohle nutny..
  def main_image_id
    if self.images.any?
      if self.images.by_main.exists?
        self.images.by_main.first.id
      else
        self.images.published.first.id
      end
    end
  end

  # TODO prehodnotit, jestli tohle nutny..
  def main_image_mini
    if self.images.any?
      if self.images.published.by_main.exists?
        self.images.published.by_main.first.image.url(:mini)
      else
        self.images.published.first.image.url(:mini)
      end
    else
      "/system/product_images/missing_mini.jpg"
    end
  end

  # TODO prehodnotit, jestli tohle nutny..
  def main_image_big
    if self.images.any?
      if self.images.published.by_main.exists?
        self.images.published.by_main.first.image.url(:max)
      else
        self.images.published.first.image.url(:max)
      end
    else
      "/system/product_images/missing.jpg"
    end
  end

  def main_price
    if self.prices.any?
      if self.prices.published.by_main.exists?
        self.prices.published.by_main.first
      else
        self.prices.published.first
      end
    end
  end

	def to_url
    title = I18n.transliterate(self.title.downcase)
    title.downcase.gsub(/[^a-z0-9]+/i, '-')+"-"+self.id.to_s  if self.title
	end
	
	def self.get_by_paramid param
		id = param.split("-").last.to_i
		Product.find(id)
		rescue
			nil
	end

  def new_product?
    (Time.zone.now.to_date - self.created_at.to_date).to_i < Setting.new_product
  end

	def bestseller?
    self.b2
  end

  def sale?
    self.sale && self.sale>0
  end

  def related_products
    related = self.relateds.sample(6)
    arr = [0]
    related.each do |rel|
      arr << rel.related_id
    end

    if related.count< 6
      cat = CategoriesProduct.where(:product_id =>self.id).pluck(:category_id)
      Product.where(:id =>
                        CategoriesProduct.where(:category_id => cat).
                            where("product_id not in (?)", arr).where("product_id <> #{self.id}").pluck(:product_id)).published.
          sample(6 - related.count).each do |product|
        arr << product.id
      end
    end
    return Product.where(:id => arr)
  end
	
   #kontrola, zda je mozne e-knihu stahnout
  def self.download?( url, code, sample)
    #link="epub" if link=="mobi"
    product = Product.get_by_paramid(url) if url
    if product.nil?
      return   I18n.t('drm.error.no-search')
    end
    code2=code
    code2="epub" if code=="mobi"
    file = Attachment.find_by_product_id_and_attachment_content_type_and_sample(product.id, AttachmentType.find_by_link(code2).content_type, sample) if AttachmentType.find_by_link(code2)
    if file.nil?
     return I18n.t('drm.error.ebook_no_exists')
    end  
  end

  def file(code, sample)
    code2=code
    code2="epub" if code=="mobi"
    file = Attachment.find_by_product_id_and_attachment_content_type_and_sample(self.id, AttachmentType.find_by_link(code2).content_type, sample) if AttachmentType.find_by_link(code2)

    if code=="mobi"
      file_name = "#{file.attachment_file_name[0,file.attachment_file_name.length - 4]}"
      dir = file.attachment.path.split("/").slice!(0...-1).join("/")
      ftp_download "#{file_name}epub", "#{dir}/#{file_name}epub"
      system(" /opt/kindlegen/kindlegen #{Rails.configuration.download_path}#{dir}/#{file_name}epub -o #{file_name}mobi ") unless File.exists?("#{dir}/#{file_name}mobi")
      file_name= "#{file_name}mobi"
      file_path = "#{dir}/#{file_name}"
    else
      ftp_download file.attachment_file_name, file.attachment.path
      file_path = file.attachment.path#"#{Rails.root}/public/#{file.attachment.path}"
      file_name = file.attachment_file_name
    end
    return file_path, file_name
  end

  def ftp_download name, path
    #puts "name: #{name}, path: #{path}"
    return if File.exists?("#{Rails.configuration.download_path}#{path}")
    ftp = Net::FTP.new(Rails.configuration.ftp_server, Rails.configuration.ftp_user, Rails.configuration.ftp_password)
    dir = path.split("/").slice!(0...-1).join("/")
    ftp.chdir(dir)
    chdir = "#{Rails.configuration.download_path}/"
    dir.split("/").each do |dir0|
      Dir.mkdir("#{chdir}#{dir0}") unless File.exists?("#{chdir}#{dir0}")
      chdir = "#{chdir}#{dir0}/"
    end
    ftp.getbinaryfile(name,"#{Rails.configuration.download_path}#{path}")
    ftp.close
  end
  
end

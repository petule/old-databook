class ProductImage < ApplicationRecord
	
	belongs_to :product
  scope :by_main,  -> { where(main: true) }
	scope :published, -> { where(pub: true) }
	has_attached_file :image, styles: { lightbox: "500x300^", max: "340x>", #:medium => "136>x180>",
																			medium: "135x180", main: "x345>", news: "x180",
																			news_width: "128x180",#,:news=>"128x180",
                                      thumb: "100x100>", mini: "52>x71>" },
														default_url: '/system/categories/missing.jpg'
	
	validates_attachment_content_type :image, content_type:  /\Aimage/
	
	validates :code, presence: true
  validates :code, uniqueness: true

	def to_s
		self.title
	end

	#jestli je vetsi sirka nez dylka
	def width?
		begin
			dim = Paperclip::Geometry.from_file(image.path(:original)).to_s.split["x"]
			dim[0]>dim[1]
		rescue
			nil
		end
	end

	def get_geometry(style = :original)
		begin
			Paperclip::Geometry.from_file(image.path(style)).to_s
		rescue
			nil
		end
	end
	
end

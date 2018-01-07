class ProductPrice < ApplicationRecord
	
	belongs_to :product
	scope :by_main,->{ where( main: true) }
	scope :by_product, lambda { |product_id| where(product_id: product_id, pub: true).order(:position) }
	scope :published,->{ where(pub: true) }

	def to_s
		self.price
	end
	
	validates :price, presence: true

  #TODO WTF ???
  def without_dph
      dph = Dph.ebook_dph
      return (((price )/(dph + 100).to_f)*100).to_f if  price
  end

  def price_info
    self.price
  end

	def to_select
		"#{self.count} #{self.unit} (#{self.price.round} Kč / 1 #{self.unit})"
	end

  def sale_price
    if self.product.sale?
      price - (self.product.sale*(self.price/100))
    else
      price
    end
  end

  def sale_currency
    if self.product.sale?
      self.product.sale*(price/100)
    else
      0
    end
  end

  def sale_percent
    if self.product.sale?
      self.product.sale.to_i
    else
      0
    end
  end

	def full_price
    if count
      sale_price * count
    else
      sale_price
    end
	end

  def sale?
    price && original_price2 && original_price2 > price
  end
end

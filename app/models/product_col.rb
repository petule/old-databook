class ProductCol < ApplicationRecord
  belongs_to :product_type

	scope :by_type_published, lambda{ |type_id| where(pub: true, product_type_id: type_id) }
  scope :by_type_product_published, lambda{ |type_id| where(pub: true, product_type_id: type_id, product_cart: true) }
  scope :published, -> { where(pub: true) }
	scope :by_title_published,lambda{ |title| where(pub: true, col: title) }
	
	def self.by_type_title(type_id, title)
		ProductCol.find_by(pub: true, product_type_id: type_id, col: title )
	end

  def to_s
    title
  end
end

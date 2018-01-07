class ProductType < ApplicationRecord
  has_many :product_cols, dependent: :destroy
  has_many :dph_product_types
  has_many :dphs, through: :dph_product_types
	after_create :insert_default_col
	
	validates :name, presence: true
  validates :code, uniqueness:  true
  validates :code, presence:  true

  def to_s
    name
  end

  def tab_array
    arr = Array.new
    arr << 'base'
    arr << 'ebookattachments' if self.code == 'ebook'
    arr << "prices"
    arr << 'related'
    arr << 'categories'

    arr
  end
	
  def insert_default_col
    i = 0
    no_cols = ['id', 'pub', 'complete', 'variant_type_id', 'category_id',
     'created_at', 'updated_at', 'dph_id', 'start_at', 'end_at', 'product_state_id']
    Product.column_names.select{|column| !no_cols.include?(column) }.each do |column|
      ProductCol.create(
          col: column, title: column, position: i, product_type_id: self.id
      )
      i += 1
    end
  end
end

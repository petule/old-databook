class Dph < ApplicationRecord
	belongs_to :language
  has_many :dph_product_types
  has_many :dphs, through: :dph_product_types

  scope :by_used, ->{ where( pub: true ).order(:position) }

  validates :val, :presence => true
  validates :val, :uniqueness => true

  def title
    "DPH #{val}%"
  end

  def to_s
    val
  end
end

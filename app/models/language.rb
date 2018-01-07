class Language < ApplicationRecord

  has_many :categories
  has_many :dphs
  belongs_to :currency
  #has_many :orders

  validates :code, :url, uniqueness: true
  validates :code, :url, presence: true

  scope :by_others, lambda { |language| where.not(id: language.id ).order(:position) }

  def to_s
   #I18n.t("model.#{self.class.name.underscore}.#{code}")
   # title
    code
  end

  def name_url
    url.delete("http://").delete("https://")
  end
end
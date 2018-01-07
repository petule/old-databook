class Publisher < ApplicationRecord
  #has_many :users
  has_many :products
  scope :by_first_char, ->{ select('distinct upper(SUBSTR(title, 1, 1)) as char ') }
  scope :by_char, lambda{ |char| where('upper(SUBSTR(title, 1, 1)) = ?', char) }

  validates :title, presence: true
  validates :title, uniqueness: true

  after_create :build_url
  after_update :build_url

  def to_s
    title
  end

  def self.by_find title
    title = I18n.transliterate(title.downcase.strip) if title
    Publisher.where("unaccent('unaccent',publishers.title) ilike ? ",
                     "%#{title}%" )
  end

  def to_url
    title = I18n.transliterate(self.title.downcase.strip)
    title.gsub(/[^a-z0-9]+/i, '-')
  end

  def build_url
    update_column(:url,self.to_url )
  end
end

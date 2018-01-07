class Menu < ApplicationRecord
  validates :code, uniqueness: true
  validates :code, presence: true

  has_many :menu_objects
  scope :by_code, lambda { |code| where(code: code).order(:position) }

  def to_s
    I18n.t("model.#{self.class.name.underscore}.#{code}")
  end
end
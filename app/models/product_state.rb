class ProductState < ApplicationRecord

  def to_s
    I18n.t("model.#{self.class.name.underscore}.#{code}")
  end
end
